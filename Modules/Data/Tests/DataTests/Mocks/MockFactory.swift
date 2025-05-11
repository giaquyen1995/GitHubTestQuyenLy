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
            siteAdmin: false,
            followers: followers,
            following: following
        )
    }
    
    static func createMockRealmUser(
        login: String = "test",
        id: Int = 1,
        followers: Int = 100,
        following: Int = 50
    ) -> RealmUser {
        let user = RealmUser()
        user.login = login
        user.id = id
        user.nodeID = "node_\(id)"
        user.avatarURL = "https://avatar/\(login)"
        user.gravatarID = "gravatar_\(id)"
        user.url = "https://api.github.com/users/\(login)"
        user.htmlURL = "https://github.com/\(login)"
        user.followersURL = "https://api.github.com/users/\(login)/followers"
        user.followingURL = "https://api.github.com/users/\(login)/following"
        user.gistsURL = "https://api.github.com/users/\(login)/gists"
        user.starredURL = "https://api.github.com/users/\(login)/starred"
        user.subscriptionsURL = "https://api.github.com/users/\(login)/subscriptions"
        user.organizationsURL = "https://api.github.com/users/\(login)/orgs"
        user.reposURL = "https://api.github.com/users/\(login)/repos"
        user.eventsURL = "https://api.github.com/users/\(login)/events"
        user.receivedEventsURL = "https://api.github.com/users/\(login)/received_events"
        user.type = "User"
        user.userViewType = "default"
        user.location = "Location"
        user.blog = "https://blog.\(login).com"
        user.siteAdmin = false
        user.followers = followers
        user.following = following
        return user
    }
}
