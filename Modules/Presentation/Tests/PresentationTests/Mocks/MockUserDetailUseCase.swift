import Foundation
import Domain
import Combine

final class MockUserDetailUseCase: UserDetailUseCaseProtocol {
    var mockError: Error?
    var mockUser: UserEntity?
    
    func fetchUserDetails(loginUserName: String) -> AnyPublisher<UserEntity, Error> {
        if let error = mockError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        if let user = mockUser {
            return Just(user)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: NSError(domain: "test", code: -1))
            .eraseToAnyPublisher()
    }
}
