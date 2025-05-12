import XCTest
import Combine
@testable import Presentation
@testable import Domain

final class UsersListViewModelTests: XCTestCase {
    private var sut: UsersListViewModel!
    private var mockUseCase: MockUserListUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockUserListUseCase()
        sut = UsersListViewModel(usersListUseCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func test_initialState() {
        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.hasLoadMore)
        XCTAssertTrue(sut.errorMessage.isEmpty)
        XCTAssertFalse(sut.showErrorAlert)
        XCTAssertEqual(sut.currentPage, 0)
    }
    
    func test_loadUsers_fromCache_whenCacheNotEmpty() {
        let cachedUsers = [MockFactory.createMockUser(login: "user1", id: 1), MockFactory.createMockUser(login: "user2", id: 2)]
        mockUseCase.mockCachedUsers = cachedUsers
        mockUseCase.mockUsers = []
        let expectation = expectation(description: "Should load cached users")
        var loadedUsers: [UserEntity] = []
        
        sut.$state
            .sink { state in
                if case .loaded(let users) = state, !users.isEmpty {
                    loadedUsers = users
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.loadUsers()
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(loadedUsers.count, 2, "Should have 2 users")
        XCTAssertEqual(loadedUsers[0].id, cachedUsers[0].id, "First user ID should match")
        XCTAssertEqual(loadedUsers[1].id, cachedUsers[1].id, "Second user ID should match")
    }
    
    func test_loadUsers_fromCache_whenCacheEmpty() {
        let expectation = expectation(description: "Should handle empty cache")
        mockUseCase.mockCachedUsers = []
        let mockUsers = [MockFactory.createMockUser(login: "user1", id: 1)]
        mockUseCase.mockUsers = mockUsers
        
        sut.$state
            .dropFirst()
            .sink { state in
                if case .loading = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
            
        sut.loadUsers()
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(sut.isLoading)
    }
        
    func test_fetchUsers_success() {
        let expectation = expectation(description: "Should fetch users")
        let mockUsers = [MockFactory.createMockUser(login: "user1", id: 1), MockFactory.createMockUser(login: "user2", id: 2)]
        mockUseCase.mockUsers = mockUsers
        
        sut.fetchUsers()
        
        sut.$state
            .dropFirst()
            .filter { state in
                if case .loaded(let users) = state, !users.isEmpty {
                    return true
                }
                return false
            }
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertEqual(sut.users.count, 2)
        XCTAssertEqual(sut.currentPage, 1)
        XCTAssertTrue(sut.hasLoadMore)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_fetchUsers_failure() {
        let expectation = expectation(description: "Should handle error")
        mockUseCase.mockError = NSError(domain: "test", code: -1)
        
        sut.fetchUsers()
        
        sut.$showErrorAlert
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.errorMessage.isEmpty)
        XCTAssertTrue(sut.showErrorAlert)
    }
    
    func test_fetchUsers_whenAlreadyLoading() {
        let expectation = expectation(description: "Should not fetch when loading")
        expectation.isInverted = true
        sut.fetchUsers()
        
        sut.fetchUsers()
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_fetchUsers_whenNoMoreData() {
        let expectation = expectation(description: "Should handle empty response")
        mockUseCase.mockUsers = []
        
        sut.fetchUsers()
        
        sut.$state
            .dropFirst()
            .filter { state in
                if case .loaded(let users) = state {
                    return true
                }
                return false
            }
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(sut.hasLoadMore)
    }
    
    // MARK: - Refresh Tests
    
    func test_refreshUsers() {
        let initialUsers = [MockFactory.createMockUser(login: "user1", id: 1), MockFactory.createMockUser(login: "user2", id: 2)]
        let refreshedUsers = [MockFactory.createMockUser(login: "user3", id: 3)]
        mockUseCase.mockUsers = initialUsers
        
        let loadExpectation = expectation(description: "Should load initial users")
        sut.loadUsers()
        
        sut.$state
            .filter { state in
                if case .loaded(let users) = state, !users.isEmpty {
                    return true
                }
                return false
            }
            .first()
            .sink { _ in
                loadExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [loadExpectation], timeout: 1)
        
        let refreshExpectation = expectation(description: "Should refresh users")
        mockUseCase.mockUsers = refreshedUsers
        
        sut.refreshUsers()
        
        sut.$state
            .filter { state in
                if case .loaded(let users) = state, users == refreshedUsers {
                    return true
                }
                return false
            }
            .first()
            .sink { _ in
                refreshExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [refreshExpectation], timeout: 1)
        
        XCTAssertEqual(sut.users, refreshedUsers)
        XCTAssertEqual(sut.currentPage, 1)
        XCTAssertTrue(sut.hasLoadMore)
    }
}
