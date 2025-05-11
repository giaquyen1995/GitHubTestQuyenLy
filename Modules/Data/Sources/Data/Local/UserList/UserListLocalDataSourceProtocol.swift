//
//  UserLocalDataSourceProtocol.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import RealmSwift

public protocol UserListLocalDataSourceProtocol {
    func getCachedUsers() -> [RealmUser]
    func saveCacheUsers(_ users: [RealmUser])
}
