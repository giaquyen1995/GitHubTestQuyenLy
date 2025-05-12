import XCTest
import Combine
@testable import Presentation
@testable import Domain

final class UserDetailViewModelTests: XCTestCase {
    private var sut: UserDetailViewModel!
    private var mockUseCase: MockUserDetailUseCase!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockUseCase = MockUserDetailUseCase()
        sut = UserDetailViewModel(loginUserName: "testUser", userDetailUseCase: mockUseCase)
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        mockUseCase = nil
        cancellables = nil
        super.tearDown()
    }
        
    func test_initialState() {
        XCTAssertNil(sut.user)
        XCTAssertEqual(sut.errorMessage, "")
        XCTAssertFalse(sut.showErrorAlert)
    }
        
    func test_fetchUserDetails_success() {
        let expectation = expectation(description: "Should fetch user details")
        let mockUser = MockFactory.createMockUser()
        mockUseCase.mockUser = mockUser
        
        sut.$state
            .dropFirst()
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
            
        sut.fetchUserDetails()
        
        wait(for: [expectation], timeout: 2)
        
        XCTAssertNotNil(sut.user)
        XCTAssertEqual(sut.user?.id, mockUser.id)
        XCTAssertEqual(sut.user?.login, mockUser.login)
        XCTAssertEqual(sut.user?.location, mockUser.location)
        XCTAssertEqual(sut.user?.followers, mockUser.followers)
        XCTAssertEqual(sut.user?.following, mockUser.following)
        XCTAssertEqual(sut.user?.blog, mockUser.blog)
        XCTAssertEqual(sut.user?.avatarURL, mockUser.avatarURL)
    }
    
    func test_fetchUserDetails_failure() {
        let expectation = expectation(description: "Should handle error")
        mockUseCase.mockError = NSError(domain: "test", code: -1)
        
        sut.$showErrorAlert
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
            
        sut.fetchUserDetails()
        
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNil(sut.user)
        XCTAssertFalse(sut.errorMessage.isEmpty)
        XCTAssertTrue(sut.showErrorAlert)
    }
    
    func test_fetchUserDetails_withInvalidAvatarURL() {
        var mockUser = MockFactory.createMockUser()
        mockUser = UserEntity(
            login: mockUser.login,
            id: mockUser.id,
            avatarURL: "invalid url",
            htmlURL: mockUser.htmlURL,
            location: mockUser.location,
            blog: mockUser.blog,
            followers: mockUser.followers,
            following: mockUser.following
        )
        mockUseCase.mockUser = mockUser
        
        sut.fetchUserDetails()
        
        XCTAssertNil(sut.user?.avatarURL)
    }
        
    func test_followersCount_withValueBelowMax() {
        var mockUser = MockFactory.createMockUser()
        mockUser = UserEntity(
            login: mockUser.login,
            id: mockUser.id,
            avatarURL: mockUser.avatarURL,
            htmlURL: mockUser.htmlURL,
            location: mockUser.location,
            blog: mockUser.blog,
            followers: 50,
            following: mockUser.following
        )
        mockUseCase.mockUser = mockUser
        
        sut.fetchUserDetails()
        let expectation = expectation(description: "Wait for user details")
        sut.$state
            .dropFirst()
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(sut.followersCount, "50")
    }
    
    func test_followersCount_withValueAboveMax() {
        var mockUser = MockFactory.createMockUser()
        mockUser = UserEntity(
            login: mockUser.login,
            id: mockUser.id,
            avatarURL: mockUser.avatarURL,
            htmlURL: mockUser.htmlURL,
            location: mockUser.location,
            blog: mockUser.blog,
            followers: 150,
            following: mockUser.following
        )
        mockUseCase.mockUser = mockUser
        
        sut.fetchUserDetails()
        let expectation = expectation(description: "Wait for user details")
        sut.$state
            .dropFirst()
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(sut.followersCount, "100+")
    }
    
    func test_followingCount_withValueBelowMax() {
        var mockUser = MockFactory.createMockUser()
        mockUser = UserEntity(
            login: mockUser.login,
            id: mockUser.id,
            avatarURL: mockUser.avatarURL,
            htmlURL: mockUser.htmlURL,
            location: mockUser.location,
            blog: mockUser.blog,
            followers: mockUser.followers,
            following: 70
        )
        mockUseCase.mockUser = mockUser
        
        sut.fetchUserDetails()
        let expectation = expectation(description: "Wait for user details")
        sut.$state
            .dropFirst()
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(sut.followingCount, "70")
    }
    
    func test_followingCount_withValueAboveMax() {
        var mockUser = MockFactory.createMockUser()
        mockUser = UserEntity(
            login: mockUser.login,
            id: mockUser.id,
            avatarURL: mockUser.avatarURL,
            htmlURL: mockUser.htmlURL,
            location: mockUser.location,
            blog: mockUser.blog,
            followers: mockUser.followers,
            following: 200
        )
        mockUseCase.mockUser = mockUser
        
        sut.fetchUserDetails()
        let expectation = expectation(description: "Wait for user details")
        sut.$state
            .dropFirst()
            .sink { state in
                if case .loaded = state {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(sut.followingCount, "100+")
    }
        
    func test_isLoading_duringFetch() {
        var loadingDetected = false
        let loadedExpectation = expectation(description: "State should change to loaded")
        let mockUser = MockFactory.createMockUser()
        mockUseCase.mockUser = mockUser
        
        sut.$state
            .sink { state in
                if case .loading = state {
                    loadingDetected = true
                }
                if case .loaded = state {
                    loadedExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        sut.fetchUserDetails()
        
        wait(for: [loadedExpectation], timeout: 2)
        XCTAssertTrue(loadingDetected, "Loading state should be detected during fetch")
    }
}
