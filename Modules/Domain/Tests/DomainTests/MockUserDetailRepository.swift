//
//  Untitled.swift
//  Domain
//
//  Created by QuyenLG on 11/5/25.
//

import Domain
import Combine

final class MockUserDetailRepository: UserDetailRepositoryProtocol {
    var mockError: Error?
    private(set) var cachedUsers: [UserEntity] = []
 
    func fetchUserDetail(loginUserName: String) -> AnyPublisher<UserEntity, Error> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(MockFactory.createMockUser())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
