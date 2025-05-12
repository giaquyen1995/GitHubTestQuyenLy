//
//  Untitled.swift
//  Presentation
//
//  Created by QuyenLG on 12/5/25.
//
import Domain

public enum UsersListState {
    case idle
    case loading
    case loaded([UserEntity])
    case loadMore([UserEntity])
    case refresh
    case error(String)
    
    var users: [UserEntity] {
        switch self {
        case .loaded(let users): return users
        case .loadMore(let oldUsers): return oldUsers
        default: return []
        }
    }
    
    var isLoading: Bool {
        switch self {
        case .loading, .loadMore: return true
        default: return false
        }
    }
    
    var errorMessage: String {
        switch self {
        case .error(let message): return message
            default: return ""
        }
    }
}
