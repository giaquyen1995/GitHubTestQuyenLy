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
            nodeID: "node_\(id)",
            avatarURL: "https://avatar/\(login)",
            gravatarID: "gravatar_\(id)",
            url: "https://api.github.com/users/\(login)",
            htmlURL: "https://github.com/\(login)",
            followersURL: "https://api.github.com/users/\(login)/followers",
            followingURL: "https://api.github.com/users/\(login)/following",
            gistsURL: "https://api.github.com/users/\(login)/gists",
            starredURL: "https://api.github.com/users/\(login)/starred",
            subscriptionsURL: "https://api.github.com/users/\(login)/subscriptions",
            organizationsURL: "https://api.github.com/users/\(login)/orgs",
            reposURL: "https://api.github.com/users/\(login)/repos",
            eventsURL: "https://api.github.com/users/\(login)/events",
            receivedEventsURL: "https://api.github.com/users/\(login)/received_events",
            type: "User",
            userViewType: "default",
            location: "Location",
            blog: "https://blog.\(login).com",
            isSiteAdmin: false,
            followers: followers,
            following: following
        )
    }
}
