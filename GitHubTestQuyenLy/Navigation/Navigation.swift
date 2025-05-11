//
//  Extension+Router.swift
//  GitHubTestQuyenLy
//
//  Created by QuyenLG on 10/5/25.
//

import SwiftUI
import Presentation

extension Router {
    func handleNavigation(for destination: Destination) -> some View {
        switch destination {
        case .userDetail(let loginUserName):
            AppDIContainer.shared.makeUserDetailView(loginName: loginUserName)
        }
    }
}
