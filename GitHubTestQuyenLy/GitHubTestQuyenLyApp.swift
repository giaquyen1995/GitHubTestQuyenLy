//
//  GitHubTestQuyenLyApp.swift
//  GitHubTestQuyenLy
//
//  Created by QuyenLG on 10/5/25.
//

import SwiftUI
import Domain
import Data
import Presentation

@main
struct GitHubTestQuyenLyApp: App {
    @StateObject var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                AppDIContainer.shared.makeUsersListView()
                    .navigationDestination(for: AppDestination.self) { des in
                        router.handleNavigation(for: des)
                    }
            }
            .environmentObject(router)
        }
    }
    
}
