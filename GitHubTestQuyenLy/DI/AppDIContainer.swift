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

public protocol AppDIContainerProtocol {
    func makeUserDetailViewModel(loginName: String) -> UserDetailViewModel
    func makeUsersListViewModel() -> UsersListViewModel
    
    func makeUserDetailView(loginName: String) -> AnyView
    func makeUsersListView() -> AnyView
}

final class AppDIContainer: AppDIContainerProtocol {
    static let shared = AppDIContainer()
    private init() {}

    private func makeAPIService() -> APIServiceProtocol {
        return APIService()
    }
    
    func makeUserDetailViewModel(loginName: String) -> UserDetailViewModel {
        let userDetailRepository = UserDetailRepository(apiService: makeAPIService())
        let userDetailUseCase = UserDetailUseCase(userDetailRepository: userDetailRepository)
        return UserDetailViewModel(loginUserName: loginName, userDetailUseCase: userDetailUseCase)
    }
    
    func makeUsersListViewModel() -> UsersListViewModel {
        let userListRepository = UserListRepository(apiService: makeAPIService())
        let usersListUseCase = UsersListUseCase(userListRepository: userListRepository)
        return UsersListViewModel(usersListUseCase: usersListUseCase)
    }
    
    func makeUserDetailView(loginName: String) -> AnyView {
        return AnyView(UserDetailView(viewModel: makeUserDetailViewModel(loginName: loginName)))
    }
    
    func makeUsersListView() -> AnyView {
        return AnyView(UsersListView(viewModel: makeUsersListViewModel()))
    }
}

