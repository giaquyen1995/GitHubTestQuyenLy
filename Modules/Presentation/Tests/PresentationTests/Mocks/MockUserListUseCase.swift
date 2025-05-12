import Foundation
import Domain
import Combine

final class MockUserListUseCase: UsersListUseCaseProtocol {
    var mockError: Error?
    var mockUsers: [UserEntity] = []
    var mockCachedUsers: [UserEntity] = []
    var saveCachedUsersCalled = false
    var pageSize: Int = 20
    var removeAllCachedCalled = false
    
    func fetchUsers(since: Int) -> AnyPublisher<[UserEntity], Error> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(mockUsers)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getCachedUsers() -> [UserEntity] {
        return mockCachedUsers
    }
    
    func saveCachedUsers(_ users: [UserEntity]) {
        saveCachedUsersCalled = true
        mockCachedUsers = users
    }
    
    func removeAllCached() {
        removeAllCachedCalled = true
        mockCachedUsers.removeAll()
    }
}
