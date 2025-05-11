//
//  UserRepository.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import Domain
import Combine

public final class UserListRepository: UserListRepositoryProtocol {
    private let apiService: APIServiceProtocol
    private let localDataSource: UserListLocalDataSourceProtocol
    
    public init(
        apiService: APIServiceProtocol,
        localDataSource: UserListLocalDataSourceProtocol = UserListLocalDataSource()
    ) {
        self.apiService = apiService
        self.localDataSource = localDataSource
    }
    
    public func fetchUsers(perPage: Int, since: Int) -> AnyPublisher<[UserEntity], any Error> {
        let request = GetUsersRequest(perPage: perPage, since: since)
        return apiService.request(
            request,
            responseType: [UserDTO].self
        )
        .map { $0.map { $0.toEntity() } }
        .eraseToAnyPublisher()
    }
    
    public func getCachedUsers() -> [UserEntity] {
        return localDataSource.getCachedUsers().map { $0.toDomain() }
    }
    
    public func saveCacheUsers(_ users: [UserEntity]) {
        let realmUsers = users.map { $0.toRealmUser() }
        localDataSource.saveCacheUsers(realmUsers)
    }
}
