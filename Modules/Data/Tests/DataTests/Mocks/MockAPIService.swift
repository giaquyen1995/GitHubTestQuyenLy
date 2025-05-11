//
//  Untitled.swift
//  Data
//
//  Created by QuyenLG on 11/5/25.
//

import Foundation
import Combine
@testable import Data

public final class MockAPIService: APIServiceProtocol {
    var mockResult: Result<Any, Error>?
    
    public func request<T>(_ request: APIRequest, responseType: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        guard let mockResult = mockResult else {
            fatalError("Mock result not set")
        }
        
        return Future<T, Error> { promise in
            switch mockResult {
            case .success(let value):
                if let typedValue = value as? T {
                    promise(.success(typedValue))
                }
            case .failure(let error):
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
