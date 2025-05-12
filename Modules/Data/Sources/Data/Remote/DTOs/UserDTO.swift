//
//  UserDTO.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import Domain
import Foundation

public struct UserDTO: Codable {
    let login: String?
    let id: Int?
    let avatarURL: String?
    let htmlURL: String?
    let location: String?
    let blog: String?
    let followers: Int?
    let following: Int?

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case location
        case blog
        case followers
        case following
    }
}

public extension UserDTO {
    func toEntity() -> UserEntity {
        return UserEntity(
            login: login ?? "",
            id: id ?? -1,
            avatarURL: avatarURL ?? "",
            htmlURL: htmlURL ?? "",
            location: location ?? "",
            blog: blog ?? "",
            followers: followers ?? 0,
            following: following ?? 0
        )
    }
}

