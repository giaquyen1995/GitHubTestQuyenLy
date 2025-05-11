//
//  APIError.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case networkError(error: Error)
    case decodingError(error: Error)
    case httpError(statusCode: Int, message: String?)
    case invalidURL
    case authenticationError
    case unknownError(message: String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .httpError(let statusCode, let message):
            return "HTTP error: \(statusCode), \(message ?? "No message")"
        case .invalidURL:
            return "The URL is invalid or cannot be constructed."
        case .authenticationError:
            return "Authentication failed. Please check your credentials or token."
        case .unknownError(let message):
            return "Unknown error: \(message)"
        }
    }
}
