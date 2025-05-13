//
//  Router.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import SwiftUI

public class Router: ObservableObject, RouterProtocol {
    @Published public var path = [AppDestination]()
    private let navigationHandler: NavigationHandler
    
    public init(navigationHandler: NavigationHandler) {
        self.navigationHandler = navigationHandler
    }
}

public extension Router {
    func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    func handleNavigation(for destination: AppDestination) -> AnyView {
        return navigationHandler.viewFor(destination: destination)
    }
}
