//
//  APIRequest.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public protocol APIRequest {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var urlRequest: URLRequest? { get }
}

public extension APIRequest {
    var baseUrl: String {
        return "https://api.github.com"
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
    
    var urlRequest: URLRequest? {
        guard let url = buildURL() else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        applyHeaders(to: &request)
        applyBody(to: &request)
        
        return request
    }
    
    private func buildURL() -> URL? {
        guard var components = URLComponents(string: baseUrl + path) else { return nil }
        components.queryItems = queryItems
        return components.url
    }
    
    private func applyHeaders(to request: inout URLRequest) {
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func applyBody(to request: inout URLRequest) {
        guard let parameters = parameters else { return }
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Error serializing parameters: \(error)")
        }
    }
}
