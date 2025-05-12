//
//  Untitled.swift
//  Data
//
//  Created by QuyenLG on 11/5/25.
//

import Foundation
@testable import Data
@testable import Domain

enum MockFactory {
    static func createMockUserDTO(
        login: String = "test",
        id: Int = 1,
        followers: Int = 100,
        following: Int = 50
    ) -> UserDTO {
        return UserDTO(
            login: login,
            id: id,
            avatarURL: "https://avatar/\(login)",
            htmlURL: "https://github.com/\(login)",
            location: "Location",
            blog: "https://blog.\(login).com",
            followers: followers,
            following: following
        )
    }
    
    static func createMockUserEntity(login: String = "test") -> UserEntity {
        createMockUserDTO(login: login).toEntity()
    }
    
    static func createMockRealmUser(
        login: String = "test",
        id: Int = 1,
        followers: Int = 100,
        following: Int = 50
    ) -> RealmUser {
        return createMockUserEntity().toRealmUser()
    }
}
