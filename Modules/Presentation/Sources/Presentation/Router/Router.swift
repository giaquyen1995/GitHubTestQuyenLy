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
    
    public func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    public func navigateBack() {
        path.removeLast()
    }
    
    public func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    public func handleNavigation(for destination: AppDestination) -> AnyView {
        return navigationHandler.viewFor(destination: destination)
    }
}
