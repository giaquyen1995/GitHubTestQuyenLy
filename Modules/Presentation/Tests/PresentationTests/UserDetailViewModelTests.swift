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
        XCTAssertEqual(sut.user?.login, mockUser.login)
        XCTAssertEqual(sut.user?.location, mockUser.location)
        XCTAssertEqual(sut.user?.followers, mockUser.followers)
        XCTAssertEqual(sut.user?.following, mockUser.following)
        XCTAssertEqual(sut.user?.blog, mockUser.blog)
        XCTAssertEqual(sut.user?.avatarURL, mockUser.avatarURL)
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
            avatarURL: "invalid url",
            htmlURL: mockUser.htmlURL,
            location: mockUser.location,
            blog: mockUser.blog,
            followers: mockUser.followers,
            following: mockUser.following
        )
        mockUseCase.mockUser = mockUser
        
        // When
        sut.fetchUserDetails()
        
        // Then
        XCTAssertNil(sut.user?.avatarURL)
    }
}
