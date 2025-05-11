//
//  Untitled.swift
//  Data
//
//  Created by QuyenLG on 11/5/25.
//

import XCTest
import Combine
@testable import Data
@testable import Domain

final class UserListRepositoryTests: XCTestCase {
    var sut: UserListRepository!
    var mockAPIService: MockAPIService!
    var mockLocalDataSource: MockUserListLocalDataSource!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        mockLocalDataSource = MockUserListLocalDataSource()
        sut = UserListRepository(
            apiService: mockAPIService,
            localDataSource: mockLocalDataSource
        )
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        mockLocalDataSource = nil
        cancellables = nil
        super.tearDown()
    }
        
    func test_fetchUsers_success() async throws {
        let mockUsers = [MockFactory.createMockUserDTO()]
        mockAPIService.mockResult = .success(mockUsers)
        
        var receivedUsers: [UserEntity]?
        var receivedError: Error?
        
        let expectation = expectation(description: "Fetch users success")
        
        sut.fetchUsers(perPage: 10, since: 0)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { users in
                    receivedUsers = users
                }
            )
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedUsers?.count, 1)
        XCTAssertEqual(receivedUsers?.first?.login, mockUsers.first?.login)
    }
    
    func test_fetchUsers_failure() async throws {
        let mockError = NSError(domain: "test", code: -1)
        mockAPIService.mockResult = .failure(mockError)
        
        var receivedUsers: [UserEntity]?
        var receivedError: Error?
        
        let expectation = expectation(description: "Fetch users failure")
        
        sut.fetchUsers(perPage: 10, since: 0)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { users in
                    receivedUsers = users
                }
            )
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertNotNil(receivedError)
        XCTAssertNil(receivedUsers)
    }
        
    func test_getCachedUsers_success() {
        let mockUsers = [MockFactory.createMockRealmUser()]
        mockLocalDataSource.mockCachedUsers = mockUsers
        
        let receivedUsers = sut.getCachedUsers()
        
        XCTAssertEqual(receivedUsers.count, 1)
        XCTAssertEqual(receivedUsers.first?.login, mockUsers.first?.login)
    }
    
    func test_saveCacheUsers_success() {
        let mockUser = MockFactory.createMockUserDTO().toEntity()
        
        sut.saveCacheUsers([mockUser])
        
        XCTAssertEqual(mockLocalDataSource.savedUsers?.count, 1)
        XCTAssertEqual(mockLocalDataSource.savedUsers?.first?.login, mockUser.login)
    }
    
    // MARK: - Additional Cache Tests
    
    func test_getCachedUsers_whenEmpty() {
        mockLocalDataSource.mockCachedUsers = nil
        let receivedUsers = sut.getCachedUsers()
        XCTAssertEqual(receivedUsers.count, 0)
    }
    
    func test_saveCacheUsers_multipleUsers() {
        let mockUsers = [
            MockFactory.createMockUserDTO(login: "user1").toEntity(),
            MockFactory.createMockUserDTO(login: "user2").toEntity(),
            MockFactory.createMockUserDTO(login: "user3").toEntity()
        ]
        
        sut.saveCacheUsers(mockUsers)
        
        XCTAssertEqual(mockLocalDataSource.savedUsers?.count, 3)
        XCTAssertEqual(
            Set(mockLocalDataSource.savedUsers?.compactMap { $0.login } ?? []),
            Set(["user1", "user2", "user3"])
        )
    }
    
    func test_saveCacheUsers_emptyArray() {
        sut.saveCacheUsers([])
        
        XCTAssertEqual(mockLocalDataSource.savedUsers?.count, 0)
    }
        
    func test_fetchUsers_withZeroPerPage() {
        let mockUsers: [UserDTO] = []
        mockAPIService.mockResult = .success(mockUsers)
        
        var receivedUsers: [UserEntity]?
        var receivedError: Error?
        
        let expectation = expectation(description: "Fetch users with zero per page")
        
        sut.fetchUsers(perPage: 0, since: 0)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { users in
                    receivedUsers = users
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedUsers?.count, 0)
    }
    
    func test_fetchUsers_withNegativeSince() {
        let mockUsers = [MockFactory.createMockUserDTO()]
        mockAPIService.mockResult = .success(mockUsers)
        
        var receivedUsers: [UserEntity]?
        var receivedError: Error?
        
        let expectation = expectation(description: "Fetch users with negative since")
        
        sut.fetchUsers(perPage: 10, since: -1)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                    }
                    expectation.fulfill()
                },
                receiveValue: { users in
                    receivedUsers = users
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedUsers?.count, 1)
    }
}

final class MockUserListLocalDataSource: UserListLocalDataSourceProtocol {
    var mockCachedUsers: [RealmUser]?
    var savedUsers: [RealmUser]?
    var didCallRemoveAllCached = false
    
    func getCachedUsers() -> [RealmUser] {
        return mockCachedUsers ?? []
    }
    
    func saveCacheUsers(_ users: [RealmUser]) {
        savedUsers = users
    }
    
    func removeAllCached() {
        didCallRemoveAllCached = true
        mockCachedUsers = nil
        savedUsers = nil
    }
}
