//
//  Untitled.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import Combine

public protocol APIServiceProtocol {
    func request<T: Codable>(_ request: APIRequest, responseType: T.Type) -> AnyPublisher<T, Error>
}

public final class APIService: APIServiceProtocol {
    // MARK: - Properties
    private let session: URLSession
    private let decoder: JSONDecoder
    private let retryCount: Int
    private let shouldLogNetworkCalls: Bool
    
    // MARK: - Initialization
    public init(
        session: URLSession = .shared,
        requestTimeout: TimeInterval = 30.0,
        resourceTimeout: TimeInterval = 60.0,
        retryCount: Int = 2,
        shouldLogNetworkCalls: Bool = true
    ) {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = requestTimeout
        configuration.timeoutIntervalForResource = resourceTimeout
        
        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
        self.retryCount = retryCount
        self.shouldLogNetworkCalls = shouldLogNetworkCalls
    }
    
    // MARK: - Public Methods
    public func request<T: Codable>(_ request: APIRequest, responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let urlRequest = request.urlRequest else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        if shouldLogNetworkCalls {
            NetworkLogger.log(request: urlRequest)
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .retry(retryCount)
            .tryMap { [weak self] data, response -> Data in
                guard let self = self else { throw APIError.unknownError(message: "Service deallocated") }
                
                if self.shouldLogNetworkCalls {
                    NetworkLogger.log(response: response, data: data, error: nil)
                }
                
                try self.validateResponse(response, data: data)
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { [weak self] error in
                guard let self = self else { return APIError.unknownError(message: "Service deallocated") }
                return self.handleError(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw APIError.authenticationError
        case 403:
            throw APIError.tokenExpired
        case 404:
            throw APIError.httpError(statusCode: httpResponse.statusCode, message: "Resource not found")
        case 500...599:
            throw APIError.serverError(message: "Server error occurred")
        default:
            let message = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            throw APIError.httpError(
                statusCode: httpResponse.statusCode,
                message: message?["message"] as? String
            )
        }
    }
    
    private func handleError(_ error: Error) -> Error {
        switch error {
        case let urlError as URLError:
            switch urlError.code {
            case .notConnectedToInternet:
                return APIError.noInternetConnection
            case .timedOut:
                return APIError.timeout
            default:
                return APIError.networkError(error: urlError)
            }
        case let decodingError as DecodingError:
            return APIError.decodingError(error: decodingError)
        case let apiError as APIError:
            return apiError
        default:
            return APIError.unknownError(message: error.localizedDescription)
        }
    }
}
