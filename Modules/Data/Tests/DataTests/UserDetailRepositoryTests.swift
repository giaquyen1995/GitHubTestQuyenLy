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

final class UserDetailRepositoryTests: XCTestCase {
    private var sut: UserDetailRepository!
    private var mockAPIService: MockAPIService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        sut = UserDetailRepository(apiService: mockAPIService)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func test_fetchUserDetail_success() async throws {
        // Given
        let expectedUser = MockFactory.createMockUserDTO()
        mockAPIService.mockResult = .success(expectedUser)
        let expectation = expectation(description: "Should receive user")
        
        // When
        var receivedUser: UserEntity?
        var receivedError: Error?
        
        sut.fetchUserDetail(loginUserName: "testUser")
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            } receiveValue: { user in
                receivedUser = user
            }
            .store(in: &cancellables)
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedUser)
        XCTAssertEqual(receivedUser?.login, expectedUser.login)
    }
    
    func test_fetchUserDetail_failure() async throws {
        // Given
        struct TestError: Error {}
        let expectedError = TestError()
        mockAPIService.mockResult = .failure(expectedError)
        let expectation = expectation(description: "Should receive error")
        
        // When
        var receivedUser: UserEntity?
        var receivedError: Error?
        
        sut.fetchUserDetail(loginUserName: "testUser")
            .sink { completion in
                if case .failure(let error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            } receiveValue: { user in
                receivedUser = user
            }
            .store(in: &cancellables)
        
        // Then
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertNotNil(receivedError)
        XCTAssertNil(receivedUser)
    }
}

