//
//  RouterProtocol.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import SwiftUI

public protocol RouterProtocol {
    associatedtype Destination = Hashable
    var path: [Destination] { get set }
    func navigate(to destination: Destination)
    func navigateBack()
    func navigateToRoot()
}
