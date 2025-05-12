//
//  Untitled.swift
//  Presentation
//
//  Created by QuyenLG on 11/5/25.
//

import Foundation
@testable import Domain

enum MockFactory {
    static func createMockUser(
        login: String = "testUser",
        id: Int = 1,
        followers: Int = 100,
        following: Int = 50
    ) -> UserEntity {
        return UserEntity(
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
}
