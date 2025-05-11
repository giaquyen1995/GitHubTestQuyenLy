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
    
    func fetchUsers(perPage: Int, since: Int) -> AnyPublisher<[UserEntity], Error> {
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
}
