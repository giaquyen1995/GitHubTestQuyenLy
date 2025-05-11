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
    public let nodeID: String
    public let avatarURL: String
    public let gravatarID: String
    public let url: String
    public let htmlURL: String
    public let followersURL: String
    public let followingURL: String
    public let gistsURL: String
    public let starredURL: String
    public let subscriptionsURL: String
    public let organizationsURL: String
    public let reposURL: String
    public let eventsURL: String
    public let receivedEventsURL: String
    public let type: String
    public let userViewType: String
    public let location: String
    public let blog: String
    public let isSiteAdmin: Bool
    public let followers: Int
    public let following: Int

    public init(
        login: String,
        id: Int,
        nodeID: String,
        avatarURL: String,
        gravatarID: String,
        url: String,
        htmlURL: String,
        followersURL: String,
        followingURL: String,
        gistsURL: String,
        starredURL: String,
        subscriptionsURL: String,
        organizationsURL: String,
        reposURL: String,
        eventsURL: String,
        receivedEventsURL: String,
        type: String,
        userViewType: String,
        location: String,
        blog: String,
        isSiteAdmin: Bool,
        followers: Int,
        following: Int
    ) {
        self.login = login
        self.id = id
        self.nodeID = nodeID
        self.avatarURL = avatarURL
        self.gravatarID = gravatarID
        self.url = url
        self.htmlURL = htmlURL
        self.followersURL = followersURL
        self.followingURL = followingURL
        self.gistsURL = gistsURL
        self.starredURL = starredURL
        self.subscriptionsURL = subscriptionsURL
        self.organizationsURL = organizationsURL
        self.reposURL = reposURL
        self.eventsURL = eventsURL
        self.receivedEventsURL = receivedEventsURL
        self.type = type
        self.userViewType = userViewType
        self.location = location
        self.blog = blog
        self.isSiteAdmin = isSiteAdmin
        self.followers = followers
        self.following = following
    }
}
