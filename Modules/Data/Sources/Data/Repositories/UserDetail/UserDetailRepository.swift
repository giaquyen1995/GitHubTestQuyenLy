//
//  UserDetailRepository.swift
//  Data
//
//  Created by QuyenLG on 11/5/25.
//

import Domain
import Combine

public final class UserDetailRepository: UserDetailRepositoryProtocol {
    private let apiService: APIServiceProtocol
    
    public init(
        apiService: APIServiceProtocol
    ) {
        self.apiService = apiService
    }
}

public extension UserDetailRepository {
    func fetchUserDetail(loginUserName: String) -> AnyPublisher<UserEntity, any Error> {
        let request = GetUserDetailRequest(loginUserName: loginUserName)
        return apiService.request(
            request,
            responseType: UserDTO.self
        )
        .map { $0.toEntity() }
        .eraseToAnyPublisher()
    }
}
