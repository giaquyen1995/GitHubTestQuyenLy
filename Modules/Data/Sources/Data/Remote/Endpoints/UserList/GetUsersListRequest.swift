//
//  GetUsersRequest.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation

struct GetUsersRequest: APIRequest {
    var perPage: Int
    var since: Int
    
    var path: String {
        return "/users"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return [
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "since", value: "\(since)")
        ]
    }
}
