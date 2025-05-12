//
//  AppNavigationHandler.swift
//  GitHubTestQuyenLy
//
//  Created by QuyenLG on 12/5/25.
//

import SwiftUI
import Presentation

class AppNavigationHandler: NavigationHandler {
    private let diContainer: AppDIContainerProtocol
    
    init(diContainer: AppDIContainerProtocol) {
        self.diContainer = diContainer
    }
    
    func viewFor(destination: AppDestination) -> AnyView {
        switch destination {
        case .userDetail(let loginUserName):
            return diContainer.makeUserDetailView(loginName: loginUserName)
        }
    }
}
