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
    
    // MARK: - Initial State Tests
    
    func test_initialState() {
        XCTAssertNil(sut.user)
        XCTAssertNil(sut.avatar)
        XCTAssertEqual(sut.name, "")
        XCTAssertEqual(sut.location, "")
        XCTAssertEqual(sut.followersCount, 0)
        XCTAssertEqual(sut.followingCount, 0)
        XCTAssertEqual(sut.blog, "")
        XCTAssertEqual(sut.errorMessage, "")
        XCTAssertFalse(sut.showErrorAlert)
    }
    
    // MARK: - Fetch User Details Tests
    
    func test_fetchUserDetails_success() {
        // Given
        let expectation = expectation(description: "Should fetch user details")
        let mockUser = MockFactory.createMockUser()
        mockUseCase.mockUser = mockUser
        
        // When
        sut.$user
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
            
        sut.fetchUserDetails()
        
        // Then
        wait(for: [expectation], timeout: 1)
        
        XCTAssertEqual(sut.user?.id, mockUser.id)
        XCTAssertEqual(sut.name, mockUser.login)
        XCTAssertEqual(sut.location, mockUser.location)
        XCTAssertEqual(sut.followersCount, mockUser.followers)
        XCTAssertEqual(sut.followingCount, mockUser.following)
        XCTAssertEqual(sut.blog, mockUser.blog)
        XCTAssertEqual(sut.avatar, URL(string: mockUser.avatarURL))
    }
    
    func test_fetchUserDetails_failure() {
        // Given
        let expectation = expectation(description: "Should handle error")
        mockUseCase.mockError = NSError(domain: "test", code: -1)
        
        // When
        sut.$showErrorAlert
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
            
        sut.fetchUserDetails()
        
        // Then
        wait(for: [expectation], timeout: 1)
        
        XCTAssertNil(sut.user)
        XCTAssertFalse(sut.errorMessage.isEmpty)
        XCTAssertTrue(sut.showErrorAlert)
    }
    
    func test_fetchUserDetails_withInvalidAvatarURL() {
        // Given
        var mockUser = MockFactory.createMockUser()
        mockUser = UserEntity(
            login: mockUser.login,
            id: mockUser.id,
            nodeID: mockUser.nodeID,
            avatarURL: "invalid url",
            gravatarID: mockUser.gravatarID,
            url: mockUser.url,
            htmlURL: mockUser.htmlURL,
            followersURL: mockUser.followersURL,
            followingURL: mockUser.followingURL,
            gistsURL: mockUser.gistsURL,
            starredURL: mockUser.starredURL,
            subscriptionsURL: mockUser.subscriptionsURL,
            organizationsURL: mockUser.organizationsURL,
            reposURL: mockUser.reposURL,
            eventsURL: mockUser.eventsURL,
            receivedEventsURL: mockUser.receivedEventsURL,
            type: mockUser.type,
            userViewType: mockUser.userViewType,
            location: mockUser.location,
            blog: mockUser.blog,
            isSiteAdmin: mockUser.isSiteAdmin,
            followers: mockUser.followers,
            following: mockUser.following
        )
        mockUseCase.mockUser = mockUser
        
        // When
        sut.fetchUserDetails()
        
        // Then
        XCTAssertNil(sut.avatar)
    }
}
