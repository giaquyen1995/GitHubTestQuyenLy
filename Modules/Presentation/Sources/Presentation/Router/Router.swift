//
//  Router.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation

public class Router: ObservableObject, RouterProtocol {
    @Published public var path = [AppDestination]()
    
    public init() { }
    
    public func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    public func navigateBack() {
        path.removeLast()
    }
    
    public func navigateToRoot() {
        path.removeLast(path.count)
    }
}
