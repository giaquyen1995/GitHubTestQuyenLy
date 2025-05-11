//
//  RealmManager.swift
//  Data
//
//  Created by QuyenLG on 10/5/25.
//

import RealmSwift

enum RealmError: Error {
    case realmNotInitialized
    case failedToWrite
}

public final class RealmManager: RealmManagerProtocol {
    private var realm: Realm?
    private let configuration: Realm.Configuration
    public static let schemaVersion: UInt64 = 1
    
    public init(configuration: Realm.Configuration = Realm.Configuration(
        schemaVersion: RealmManager.schemaVersion,
        migrationBlock: { migration, oldSchemaVersion in
            
        }
    )) {
        self.configuration = configuration

        do {
            self.realm = try Realm(configuration: configuration)
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    public func get<T: Object>(_ type: T.Type) -> [T] {
        guard let realm = realm else {
            return []
        }
        let objects = realm.objects(type)
        return Array(objects)
    }
    
    private func writeToRealm<T: Object>(_ objects: [T], update: Realm.UpdatePolicy = .modified) throws {
        guard let realm = realm else {
            throw RealmError.realmNotInitialized
        }
        do {
            try realm.write {
                realm.add(objects, update: update)
            }
        } catch {
            throw RealmError.failedToWrite
        }
    }
    
    // Write a single object
    public func write<T: Object>(_ object: T) throws {
        try writeToRealm([object])
    }
    
    // Write multiple objects
    public func write<T: Object>(_ objects: [T]) throws {
        try writeToRealm(objects)
    }
    
    // Delete all objects of a given type
    public func deleteAll<T: Object>(_ type: T.Type) throws {
        guard let realm = realm else {
            throw RealmError.realmNotInitialized
        }
        
        do {
            try realm.write {
                let objects = realm.objects(type)
                realm.delete(objects)
            }
        } catch {
            throw RealmError.failedToWrite
        }
    }
}
