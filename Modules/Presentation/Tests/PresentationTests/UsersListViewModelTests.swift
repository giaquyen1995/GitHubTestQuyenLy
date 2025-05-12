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
        let cachedUsers = [MockFactory.createMockUser(id: 1), MockFactory.createMockUser(id: 2)]
        mockUseCase.mockCachedUsers = cachedUsers
        
        sut.loadUsers()
        
        XCTAssertEqual(sut.users.count, 2)
        XCTAssertEqual(sut.users[0].id, cachedUsers[0].id)
    }
    
    func test_loadUsers_fromCache_whenCacheEmpty() {
        mockUseCase.mockCachedUsers = []
        
        sut.loadUsers()
        
        XCTAssertTrue(sut.users.isEmpty)
    }
    
    // MARK: - Fetch Users Tests
    
    func test_fetchUsers_success() {
        let expectation = expectation(description: "Should fetch users")
        let mockUsers = [MockFactory.createMockUser(id: 1), MockFactory.createMockUser(id: 2)]
        mockUseCase.mockUsers = mockUsers
        
        sut.fetchUsers()
        
        sut.$state
            .dropFirst()
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
        // Given
        let expectation = expectation(description: "Should handle empty response")
        mockUseCase.mockUsers = []
        
        // When
        sut.fetchUsers()
        
        // Observe hasLoadMore changes
        sut.$hasLoadMore
            .dropFirst()
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
        // Given
        let initialUsers = [MockFactory.createMockUser(id: 1), MockFactory.createMockUser(id: 2)]
        let refreshedUsers = [MockFactory.createMockUser(id: 3)]
        mockUseCase.mockUsers = initialUsers
        
        // When - Initial Load
        let loadExpectation = expectation(description: "Should load initial users")
        sut.loadUsers()
        
        // Wait for initial load
        sut.$state
            .filter { !$0.users.isEmpty }
            .first()
            .sink { _ in
                loadExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [loadExpectation], timeout: 1)
        
        // When - Refresh
        let refreshExpectation = expectation(description: "Should refresh users")
        mockUseCase.mockUsers = refreshedUsers
        
        let refreshSubscription = sut.$state
            .dropFirst()
            .filter { $0.users == refreshedUsers }
            .first()
            .sink { _ in
                refreshExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.refreshUsers()
        
        // Then
        wait(for: [refreshExpectation], timeout: 1)
        
        XCTAssertEqual(sut.users, refreshedUsers)
        XCTAssertEqual(sut.currentPage, 1)
        XCTAssertTrue(sut.hasLoadMore)
    }
}
