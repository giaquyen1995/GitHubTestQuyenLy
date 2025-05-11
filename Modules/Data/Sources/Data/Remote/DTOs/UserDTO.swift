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
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url: String?
    let htmlURL: String?
    let followersURL: String?
    let followingURL: String?
    let gistsURL: String?
    let starredURL: String?
    let subscriptionsURL: String?
    let organizationsURL: String?
    let reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let userViewType: String?
    let location: String?
    let blog: String?
    let siteAdmin: Bool?
    let followers: Int?
    let following: Int?

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case userViewType = "user_view_type"
        case location
        case blog
        case siteAdmin = "site_admin"
        case followers
        case following
    }
}

public extension UserDTO {
    func toEntity() -> UserEntity {
        return UserEntity(
            login: login ?? "",
            id: id ?? -1,
            nodeID: nodeID ?? "",
            avatarURL: avatarURL ?? "",
            gravatarID: gravatarID ?? "",
            url: url ?? "",
            htmlURL: htmlURL ?? "",
            followersURL: followersURL ?? "",
            followingURL: followingURL ?? "",
            gistsURL: gistsURL ?? "",
            starredURL: starredURL ?? "",
            subscriptionsURL: subscriptionsURL ?? "",
            organizationsURL: organizationsURL ?? "",
            reposURL: reposURL ?? "",
            eventsURL: eventsURL ?? "",
            receivedEventsURL: receivedEventsURL ?? "",
            type: type ?? "",
            userViewType: userViewType ?? "",
            location: location ?? "",
            blog: blog ?? "",
            isSiteAdmin: siteAdmin ?? false,
            followers: followers ?? 0,
            following: following ?? 0
        )
    }
}

