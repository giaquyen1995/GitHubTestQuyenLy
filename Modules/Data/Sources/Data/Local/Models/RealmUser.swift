//
//  Untitled.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import Domain
import RealmSwift

public class RealmUser: Object {
    @Persisted var login: String?
    @Persisted var id: Int = 0
    @Persisted var nodeID: String?
    @Persisted var avatarURL: String?
    @Persisted var gravatarID: String?
    @Persisted var url: String?
    @Persisted var htmlURL: String?
    @Persisted var followersURL: String?
    @Persisted var followingURL: String?
    @Persisted var gistsURL: String?
    @Persisted var starredURL: String?
    @Persisted var subscriptionsURL: String?
    @Persisted var organizationsURL: String?
    @Persisted var reposURL: String?
    @Persisted var eventsURL: String?
    @Persisted var receivedEventsURL: String?
    @Persisted var type: String?
    @Persisted var userViewType: String?
    @Persisted var location: String?
    @Persisted var blog: String?
    @Persisted var siteAdmin: Bool = false

    @Persisted var followers: Int = 0
    @Persisted var following: Int = 0

    // Add a primary key if needed
    public override static func primaryKey() -> String? {
        return "login"  // Assuming 'login' is unique, otherwise choose another field
    }
}

extension RealmUser {
    convenience init(from dto: UserDTO) {
        self.init()
        self.login = dto.login
        self.id = dto.id ?? 0
        self.nodeID = dto.nodeID
        self.avatarURL = dto.avatarURL
        self.gravatarID = dto.gravatarID
        self.url = dto.url
        self.htmlURL = dto.htmlURL
        self.followersURL = dto.followersURL
        self.followingURL = dto.followingURL
        self.gistsURL = dto.gistsURL
        self.starredURL = dto.starredURL
        self.subscriptionsURL = dto.subscriptionsURL
        self.organizationsURL = dto.organizationsURL
        self.reposURL = dto.reposURL
        self.eventsURL = dto.eventsURL
        self.receivedEventsURL = dto.receivedEventsURL
        self.type = dto.type
        self.userViewType = dto.userViewType
        self.location = dto.location
        self.blog = dto.blog
        self.siteAdmin = dto.siteAdmin ?? false
        self.followers = dto.followers ?? 0
        self.following = dto.following ?? 0
    }
}

extension RealmUser {
    func toDomain() -> UserEntity {
        return UserEntity(
            login: self.login ?? "",
            id: self.id,
            nodeID: self.nodeID ?? "",
            avatarURL: self.avatarURL ?? "",
            gravatarID: self.gravatarID ?? "",
            url: self.url ?? "",
            htmlURL: self.htmlURL ?? "",
            followersURL: self.followersURL ?? "",
            followingURL: self.followingURL ?? "",
            gistsURL: self.gistsURL ?? "",
            starredURL: self.starredURL ?? "",
            subscriptionsURL: self.subscriptionsURL ?? "",
            organizationsURL: self.organizationsURL ?? "",
            reposURL: self.reposURL ?? "",
            eventsURL: self.eventsURL ?? "",
            receivedEventsURL: self.receivedEventsURL ?? "",
            type: self.type ?? "",
            userViewType: self.userViewType ?? "",
            location: self.location ?? "",
            blog: self.blog ?? "",
            isSiteAdmin: self.siteAdmin,
            followers: self.followers,
            following: self.following
        )
    }
}

extension UserEntity {
    func toRealmUser() -> RealmUser {
        let realmUser = RealmUser()
        realmUser.login = self.login
        realmUser.id = self.id
        realmUser.nodeID = self.nodeID
        realmUser.avatarURL = self.avatarURL
        realmUser.gravatarID = self.gravatarID
        realmUser.url = self.url
        realmUser.htmlURL = self.htmlURL
        realmUser.followersURL = self.followersURL
        realmUser.followingURL = self.followingURL
        realmUser.gistsURL = self.gistsURL
        realmUser.starredURL = self.starredURL
        realmUser.subscriptionsURL = self.subscriptionsURL
        realmUser.organizationsURL = self.organizationsURL
        realmUser.reposURL = self.reposURL
        realmUser.eventsURL = self.eventsURL
        realmUser.receivedEventsURL = self.receivedEventsURL
        realmUser.type = self.type
        realmUser.userViewType = self.userViewType
        realmUser.location = self.location
        realmUser.blog = self.blog
        realmUser.siteAdmin = self.isSiteAdmin
        realmUser.followers = self.followers
        realmUser.following = self.following
        return realmUser
    }
}
