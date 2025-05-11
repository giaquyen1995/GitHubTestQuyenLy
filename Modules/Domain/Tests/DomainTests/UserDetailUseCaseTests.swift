//
//  Untitled.swift
//  Domain
//
//  Created by QuyenLG on 11/5/25.
//

import XCTest
import Combine
@testable import Domain

final class UserDetailUseCaseTests: XCTestCase {
    private var sut: UserDetailUseCase!
    private var mockRepository: MockUserDetailRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockUserDetailRepository()
        sut = UserDetailUseCase(userDetailRepository: mockRepository)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchUserDetails_success() {
        let expectation = expectation(description: "Should receive user details")
        var receivedUser: UserEntity?
        var receivedError: Error?
        
        sut.fetchUserDetails(loginUserName: "testUser")
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            } receiveValue: { user in
                receivedUser = user
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedUser)
        XCTAssertEqual(receivedUser?.login, "testUser")
    }
    
    func test_fetchUserDetails_failure() {
        mockRepository.mockError = NSError(domain: "test", code: -1)
        let expectation = expectation(description: "Should receive error")
        var receivedUser: UserEntity?
        var receivedError: Error?
        
        sut.fetchUserDetails(loginUserName: "testUser")
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            } receiveValue: { user in
                receivedUser = user
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(receivedError)
        XCTAssertNil(receivedUser)
    }
    
    func test_fetchUserDetails_withEmptyUsername() {
        let expectation = expectation(description: "Should handle empty username")
        var receivedUser: UserEntity?
        var receivedError: Error?
        
        sut.fetchUserDetails(loginUserName: "")
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            } receiveValue: { user in
                receivedUser = user
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedUser)
        XCTAssertEqual(receivedUser?.login, "testUser")
    }
}

