import Domain

public enum UserDetailState {
    case idle
    case loading
    case loaded(UserEntity)
    case error(String)
    
    var user: UserEntity? {
        switch self {
        case .loaded(let user):
            return user
        default:
            return nil
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    var errorMessage: String {
        switch self {
        case .error(let message):
            return message
        default:
            return ""
        }
    }
}
