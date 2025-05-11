//
//  PaginationPolicy.swift
//  Domain
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation

public protocol PagingConfiguration {
    var pageSize: Int { get }
}

public struct UserListPagingConfiguration: PagingConfiguration {
    public init() { }
    public let pageSize: Int = 20
}
