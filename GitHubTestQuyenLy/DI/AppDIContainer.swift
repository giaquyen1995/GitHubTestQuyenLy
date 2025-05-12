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
    func makeRouter() -> Router
}

final class AppDIContainer: AppDIContainerProtocol {
    static let shared = AppDIContainer()
    private init() {}

    private lazy var apiService: APIServiceProtocol = APIService()
    private lazy var navigationHandler: AppNavigationHandler = AppNavigationHandler(diContainer: self)

    func makeUserDetailViewModel(loginName: String) -> UserDetailViewModel {
        let userDetailRepository = UserDetailRepository(apiService: apiService)
        let userDetailUseCase = UserDetailUseCase(userDetailRepository: userDetailRepository)
        return UserDetailViewModel(loginUserName: loginName, userDetailUseCase: userDetailUseCase)
    }
    
    func makeUsersListViewModel() -> UsersListViewModel {
        let userListRepository = UserListRepository(apiService: apiService)
        let usersListUseCase = UsersListUseCase(userListRepository: userListRepository)
        return UsersListViewModel(usersListUseCase: usersListUseCase)
    }
    
    func makeUserDetailView(loginName: String) -> AnyView {
        return AnyView(UserDetailView(viewModel: makeUserDetailViewModel(loginName: loginName)))
    }
    
    func makeUsersListView() -> AnyView {
        return AnyView(UsersListView(viewModel: makeUsersListViewModel()))
    }
    
    func makeRouter() -> Router {
        return Router(navigationHandler: navigationHandler)
    }
}

