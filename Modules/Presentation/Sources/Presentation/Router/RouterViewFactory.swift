//
//  RouterViewFactory.swift
//  Presentation
//
//  Created by QuyenLG on 12/5/25.
//

import SwiftUI

public extension Router {
    func handleNavigation(using navigationHandler: NavigationHandler, for destination: AppDestination) -> AnyView {
        return navigationHandler.viewFor(destination: destination)
    }
}
