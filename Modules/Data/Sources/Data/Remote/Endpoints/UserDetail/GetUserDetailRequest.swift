//
//  Untitled.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation

struct GetUserDetailRequest: APIRequest {
    let loginUserName: String
    
    var path: String {
        return "/users/\(loginUserName)"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
