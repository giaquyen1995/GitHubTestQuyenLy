//
//  UserLocalDataSource.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import RealmSwift

public final class UserListLocalDataSource: UserListLocalDataSourceProtocol {
    private let realmManager: RealmManagerProtocol
    
    public init(realmManager: RealmManagerProtocol = RealmManager()) {
        self.realmManager = realmManager
    }
}

public extension UserListLocalDataSource {
    func getCachedUsers() -> [RealmUser] {
        return realmManager.get(RealmUser.self)
    }
    
    func saveCacheUsers(_ users: [RealmUser]) {
        do {
            try realmManager.write(users)
        } catch {
            print("Failed to cache users: \(error.localizedDescription)")
        }
    }
    
    func removeAllCached() {
        do {
            try realmManager.deleteAll(RealmUser.self)
        } catch {
            print("Failed to remove cached users: \(error.localizedDescription)")
        }
    }
}
