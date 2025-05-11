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
    
    private let session: URLSession
    
    public init(
        session: URLSession = .shared,
        requestTimeout: TimeInterval = 30.0,
        resourceTimeout: TimeInterval = 60.0
    ) {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = requestTimeout
        configuration.timeoutIntervalForResource = resourceTimeout
    
        self.session = URLSession(configuration: configuration)
    }
    
    public func request<T: Codable>(_ request: APIRequest, responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let urlRequest = request.urlRequest else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { [weak self] error in
                guard let self else { return APIError.networkError(error: error) }
                return self.handleError(error)
            }
            .eraseToAnyPublisher()
    }
    
    private func handleError(_ error: Error) -> Error {
        if let urlError = error as? URLError {
            return APIError.networkError(error: urlError)
        }
        
        if let decodingError = error as? DecodingError {
            return APIError.decodingError(error: decodingError)
        }
        
        if let httpResponseError = error as? HTTPURLResponse {
            return APIError.httpError(statusCode: httpResponseError.statusCode, message: httpResponseError.allHeaderFields["message"] as? String)
        }
        
        return APIError.unknownError(message: error.localizedDescription)
    }
}
