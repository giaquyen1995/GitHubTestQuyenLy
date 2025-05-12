//
//  NavigationHandler.swift
//  Presentation
//
//  Created by QuyenLG on 12/5/25.
//

import SwiftUI

public protocol NavigationHandler {
    func viewFor(destination: AppDestination) -> AnyView
}
