//
//  UserDetailUseCase.swift
//  Domain
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import Combine

public protocol UserDetailUseCaseProtocol {
    func fetchUserDetails(loginUserName: String) -> AnyPublisher<UserEntity, Error>
}

public final class UserDetailUseCase: UserDetailUseCaseProtocol {
    private let userDetailRepository: UserDetailRepositoryProtocol
    
    public init(userDetailRepository: UserDetailRepositoryProtocol) {
        self.userDetailRepository = userDetailRepository
    }
    
}

public extension UserDetailUseCase {
    func fetchUserDetails(loginUserName: String) -> AnyPublisher<UserEntity, any Error> {
        return userDetailRepository.fetchUserDetail(loginUserName: loginUserName)
    }
}
