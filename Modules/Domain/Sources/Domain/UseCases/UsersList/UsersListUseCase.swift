//
//  UsersListUseCase.swift
//  Domain
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import Combine

public protocol UsersListUseCaseProtocol {
    func fetchUsers(since: Int) -> AnyPublisher<[UserEntity], Error>
    func getCachedUsers() -> [UserEntity]
    func saveCachedUsers(_ users: [UserEntity])
    func removeAllCached()
    var pageSize: Int { get }
}

public final class UsersListUseCase: UsersListUseCaseProtocol {
    public var pageSize: Int = 20
    private let userListRepository: UserListRepositoryProtocol
    
    public init(
        userListRepository: UserListRepositoryProtocol
    ) {
        self.userListRepository = userListRepository
    }
    
}

public extension UsersListUseCase {
    func fetchUsers(since: Int) -> AnyPublisher<[UserEntity], any Error> {
        return userListRepository.fetchUsers(
            perPage: pageSize,
            since: since
        )
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveOutput: { [weak self] users in
            self?.saveCachedUsers(users)
        })
        .eraseToAnyPublisher()
    }
    
    func getCachedUsers() -> [UserEntity] {
        return userListRepository.getCachedUsers()
    }
    
    func saveCachedUsers(_ users: [UserEntity]) {
        userListRepository.saveCacheUsers(users)
    }
    
    func removeAllCached() {
        userListRepository.removeAllCached()
    }
}
