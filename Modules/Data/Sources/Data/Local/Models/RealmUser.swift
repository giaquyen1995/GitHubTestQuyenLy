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
    @Persisted var avatarURL: String?
    @Persisted var htmlURL: String?
    @Persisted var location: String?
    @Persisted var blog: String?
    @Persisted var followers: Int = 0
    @Persisted var following: Int = 0

    public override static func primaryKey() -> String? {
        return "login"
    }
    convenience init(from dto: UserDTO) {
        self.init()
        self.login = dto.login
        self.id = dto.id ?? 0
        self.avatarURL = dto.avatarURL
        self.htmlURL = dto.htmlURL
        self.location = dto.location
        self.blog = dto.blog
        self.followers = dto.followers ?? 0
        self.following = dto.following ?? 0
    }
}

extension RealmUser {
    func toDomain() -> UserEntity {
        return UserEntity(
            login: self.login ?? "",
            id: self.id,
            avatarURL: self.avatarURL ?? "",
            htmlURL: self.htmlURL ?? "",
            location: self.location ?? "",
            blog: self.blog ?? "",
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
        realmUser.avatarURL = self.avatarURL
        realmUser.htmlURL = self.htmlURL
        realmUser.location = self.location
        realmUser.blog = self.blog
        realmUser.followers = self.followers
        realmUser.following = self.following
        return realmUser
    }
}
