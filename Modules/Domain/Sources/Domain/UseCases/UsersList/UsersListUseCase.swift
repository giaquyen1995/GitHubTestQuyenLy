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
    var pagingConfiguration: PagingConfiguration { get }
}

public final class UsersListUseCase: UsersListUseCaseProtocol {
    public var pagingConfiguration: PagingConfiguration
    private let userListRepository: UserListRepositoryProtocol
    
    public init(
        pagingConfiguration: PagingConfiguration = UserListPagingConfiguration(),
        userListRepository: UserListRepositoryProtocol
    ) {
        self.pagingConfiguration = pagingConfiguration
        self.userListRepository = userListRepository
    }
    
    public func fetchUsers(since: Int) -> AnyPublisher<[UserEntity], any Error> {
        return userListRepository.fetchUsers(
            perPage: pagingConfiguration.pageSize,
            since: since
        )
        .receive(on: DispatchQueue.main)
        .handleEvents(receiveOutput: { [weak self] users in
            if since == 0 {
                self?.saveCachedUsers(users)
            }
        })
        .eraseToAnyPublisher()
    }
    
    public func getCachedUsers() -> [UserEntity] {
        return userListRepository.getCachedUsers()
    }
    
    public func saveCachedUsers(_ users: [UserEntity]) {
        userListRepository.saveCacheUsers(users)
    }
}
