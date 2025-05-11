//
//  DIContainer.swift
//  GitHubTestQuyenLy
//
//  Created by QuyenLG on 10/5/25.
//

import Domain
import Data
import Presentation
import SwiftUI

final class AppDIContainer {
    static let shared = AppDIContainer()
    private init() {}

    private func makeAPIService() -> APIServiceProtocol {
        return APIService()
    }
    
    private func makeUserListRepository() -> UserListRepositoryProtocol {
        return UserListRepository(apiService: makeAPIService())
    }
    
    private func makeUserDetailRepository() -> UserDetailRepositoryProtocol {
        return UserDetailRepository(apiService: makeAPIService())
    }
    
    func makeUserDetailViewModel(loginName: String) -> UserDetailViewModel {
        let userDetailUseCase = UserDetailUseCase(userDetailRepository: makeUserDetailRepository())
        return UserDetailViewModel(loginUserName: loginName, userDetailUseCase: userDetailUseCase)
    }
    
    func makeUsersListViewModel() -> UsersListViewModel {
        let usersListUseCase = UsersListUseCase(userListRepository: makeUserListRepository())
        return UsersListViewModel(usersListUseCase: usersListUseCase)
    }
    
    func makeUserDetailView(loginName: String) -> some View {
        return UserDetailView(viewModel: makeUserDetailViewModel(loginName: loginName))
    }
    
    func makeUsersListView() -> some View {
        return UsersListView(viewModel: makeUsersListViewModel())
    }
}

