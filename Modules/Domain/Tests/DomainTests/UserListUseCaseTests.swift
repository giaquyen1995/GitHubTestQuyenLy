//
//  Untitled 3.swift
//  Domain
//
//  Created by QuyenLG on 11/5/25.
//

import XCTest
import Combine
@testable import Domain

final class UserListUseCaseTests: XCTestCase {
    private var sut: UsersListUseCase!
    private var mockRepository: MockUserListRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserListRepository()
        sut = UsersListUseCase(userListRepository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    
    func test_pagingConfiguration_defaultValues() {
        XCTAssertEqual(sut.pagingConfiguration.pageSize, 20)
    }
    
    func test_pagingConfiguration_customValues() {
        struct CustomPagingConfig: PagingConfiguration {
            let pageSize: Int = 30
        }
        sut = UsersListUseCase(
            pagingConfiguration: CustomPagingConfig(),
            userListRepository: mockRepository
        )
        XCTAssertEqual(sut.pagingConfiguration.pageSize, 30)
    }
        
    func test_fetchUsers_success() {
        let expectation = expectation(description: "Should receive users")
        var receivedUsers: [UserEntity]?
        var receivedError: Error?
        
        sut.fetchUsers(since: 0)
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            } receiveValue: { users in
                receivedUsers = users
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedUsers)
        XCTAssertEqual(receivedUsers?.count, 2)
    }
        
    func test_getCachedUsers() {
        let users = sut.getCachedUsers()
        XCTAssertEqual(users.count, 2)
    }
    
    func test_saveCachedUsers() {
        let usersToSave = [
            MockFactory.createMockUser(),
            MockFactory.createMockUser()
        ]
        
        sut.saveCachedUsers(usersToSave)
        XCTAssertEqual(mockRepository.cachedUsers.count, 2)
    }
}
