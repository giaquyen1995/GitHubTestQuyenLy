import XCTest
import RealmSwift
@testable import Data

final class RealmManagerTests: XCTestCase {
    var realmManager: RealmManager!
    var testRealm: Realm?
    
    override func setUp() {
        super.setUp()
        var config = Realm.Configuration()
        config.inMemoryIdentifier = self.name
        realmManager = RealmManager(configuration: config)
        testRealm = try? Realm(configuration: config)
    }
    
    override func tearDown() {
        if let realm = testRealm {
            try? realm.write {
                realm.deleteAll()
            }
        }
        realmManager = nil
        testRealm = nil
        super.tearDown()
    }
    
    func test_write_singleObject_success() throws {
        let name = "test_user"
        let user = RealmUser()
        user.login = name
        
        try realmManager.write(user)
        
        let results = realmManager.get(RealmUser.self)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.login, name)
    }
    
    func test_update_singleObject() throws {
        let user = RealmUser()
        user.login = "test_user"
        user.followers = 0
        try realmManager.write(user)
        
        var results = realmManager.get(RealmUser.self)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.followers, 0)
        
        let updatedUser = RealmUser()
        updatedUser.login = "test_user"
        updatedUser.followers = 100
        try realmManager.write(updatedUser)
        
        results = realmManager.get(RealmUser.self)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.followers, 100)
        XCTAssertEqual(results.first?.login, "test_user")
    }
    
    func test_write_multipleObjects_success() throws {
        let user1 = RealmUser()
        user1.login = "join"
        let user2 = RealmUser()
        user2.login = "lee"
        
        try realmManager.write([user1, user2])
        
        let results = realmManager.get(RealmUser.self)
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.contains { $0.login == "join" })
        XCTAssertTrue(results.contains { $0.login == "lee" })
    }
    
    func test_write_emptyArray() throws {
        try realmManager.write([RealmUser]())
        
        let results = realmManager.get(RealmUser.self)
        XCTAssertEqual(results.count, 0)
    }
    
    func test_get_noObjects() {
        let results = realmManager.get(RealmUser.self)
        
        XCTAssertEqual(results.count, 0)
    }
    
    func test_get_multipleObjects() throws {
        let users = ["user1", "user2", "user3"].map { login in
            let user = RealmUser()
            user.login = login
            return user
        }
        
        try realmManager.write(users)
        
        let results = realmManager.get(RealmUser.self)
        XCTAssertEqual(results.count, 3)
        XCTAssertEqual(Set(results.map { $0.login ?? "" }), Set(["user1", "user2", "user3"]))
    }
    
    func test_write_withInvalidConfiguration() {
        let invalidConfig = Realm.Configuration(
            fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("invalid/realm/path.realm")
        )
        let invalidManager = RealmManager(configuration: invalidConfig)
        
        XCTAssertThrowsError(try invalidManager.write([RealmUser]())) { error in
            XCTAssertTrue(error is RealmError)
            XCTAssertEqual(error as? RealmError, .realmNotInitialized)
        }
    }
    
    func test_removeAll_success() throws {
        let users = ["user1", "user2", "user3"].map { login in
            let user = RealmUser()
            user.login = login
            return user
        }
        
        try realmManager.write(users)
        
        var results = realmManager.get(RealmUser.self)
        XCTAssertEqual(results.count, 3)
        
        try realmManager.deleteAll(RealmUser.self)
        
        results = realmManager.get(RealmUser.self)
        XCTAssertEqual(results.count, 0)
    }
    
    func test_removeAll_withEmptyDatabase() throws {
        let initialResults = realmManager.get(RealmUser.self)
        XCTAssertEqual(initialResults.count, 0)
        
        try realmManager.deleteAll(RealmUser.self)
        
        let results = realmManager.get(RealmUser.self)
        XCTAssertEqual(results.count, 0)
    }
    
    func test_removeAll_withInvalidConfiguration() {
        let invalidConfig = Realm.Configuration(
            fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("invalid/realm/path.realm")
        )
        let invalidManager = RealmManager(configuration: invalidConfig)
        
        XCTAssertThrowsError(try invalidManager.deleteAll(RealmUser.self)) { error in
            XCTAssertTrue(error is RealmError)
            XCTAssertEqual(error as? RealmError, .realmNotInitialized)
        }
    }
}
