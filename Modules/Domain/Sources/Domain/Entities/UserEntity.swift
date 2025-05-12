//
//  UserEntity.swift
//  Domain
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation

public struct UserEntity: Sendable, Identifiable, Equatable {
    public let login: String
    public let id: Int
    public let avatarURL: String
    public let htmlURL: String
    public let location: String
    public let blog: String
    public let followers: Int
    public let following: Int

    public init(
        login: String,
        id: Int,
        avatarURL: String,
        htmlURL: String,
        location: String,
        blog: String,
        followers: Int,
        following: Int
    ) {
        self.login = login
        self.id = id
        self.avatarURL = avatarURL
        self.htmlURL = htmlURL
        self.location = location
        self.blog = blog
        self.followers = followers
        self.following = following
    }
}
