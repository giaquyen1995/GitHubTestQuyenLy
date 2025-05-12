//
//  Untitled 2.swift
//  Domain
//
//  Created by QuyenLG on 11/5/25.
//

import Domain
import Combine

final class MockUserListRepository: UserListRepositoryProtocol {
    private(set) var cachedUsers: [UserEntity] = []
    var didCallRemoveAllCached = false
    var mockError: Error?
    
    func fetchUsers(perPage: Int, since: Int) -> AnyPublisher<[UserEntity], Error> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return Just(
            [
                MockFactory.createMockUser(),
                MockFactory.createMockUser(),
            ]
        )
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    }
    
    func getCachedUsers() -> [Domain.UserEntity] {
        return [
            MockFactory.createMockUser(),
            MockFactory.createMockUser(),
        ]
    }
    
    func saveCacheUsers(_ users: [Domain.UserEntity]) {
        cachedUsers.append(contentsOf: users)
    }
    
    func removeAllCached() {
        didCallRemoveAllCached = true
        cachedUsers.removeAll()
    }
}
