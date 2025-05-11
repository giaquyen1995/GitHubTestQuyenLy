//
//  UserRepositoryProtocol.swift
//  Domain
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import Combine

public protocol UserListRepositoryProtocol {
    func fetchUsers(perPage: Int, since: Int) -> AnyPublisher<[UserEntity], Error>
    func getCachedUsers() -> [UserEntity]
    func saveCacheUsers(_ users: [UserEntity])
}
