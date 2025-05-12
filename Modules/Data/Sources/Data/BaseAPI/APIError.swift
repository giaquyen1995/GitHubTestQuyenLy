//
//  APIError.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation

public enum APIError: LocalizedError {
    case invalidURL
    case networkError(error: Error)
    case noInternetConnection
    case timeout
    case httpError(statusCode: Int, message: String?)
    case serverError(message: String)
    case invalidResponse
    case decodingError(error: Error)
    case invalidData
    case authenticationError
    case tokenExpired
    case unknownError(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid or malformed."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .noInternetConnection:
            return "No internet connection available."
        case .timeout:
            return "The request timed out."
        case .httpError(let statusCode, let message):
            return "Server error (\(statusCode)): \(message ?? "No additional information")"
        case .serverError(let message):
            return "Server error: \(message)"
        case .invalidResponse:
            return "The server response was invalid."
        case .decodingError(let error):
            return "Failed to process the response: \(error.localizedDescription)"
        case .invalidData:
            return "The data received was invalid."
        case .authenticationError:
            return "Authentication failed. Please sign in again."
        case .tokenExpired:
            return "Your session has expired. Please sign in again."
        case .unknownError(let message):
            return "An unexpected error occurred: \(message)"
        }
    }
    
    public static func map(_ error: Error) -> APIError {
        switch error {
        case let urlError as URLError:
            switch urlError.code {
            case .notConnectedToInternet:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            default:
                return .networkError(error: urlError)
            }
        case let apiError as APIError:
            return apiError
        default:
            return .unknownError(message: error.localizedDescription)
        }
    }
}
