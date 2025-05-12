//
//  UsersListViewModel.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import Domain
import Combine

public protocol UsersListViewModelInput {
    func loadUsers()
    func fetchUsers()
    func refreshUsers()
    func isLastItem(_ user: UserEntity) -> Bool
}

public protocol UsersListViewModelOutput {
    var users: [UserEntity] { get }
    var isLoading: Bool { get }
    var hasLoadMore: Bool { get }
    var errorMessage: String { get }
    var showErrorAlert: Bool { get set }
}

public final class UsersListViewModel: ObservableObject, UsersListViewModelInput, UsersListViewModelOutput {
    @Published public private(set) var users: [UserEntity] = []
    @Published public private(set) var isLoading = false
    @Published public private(set) var hasLoadMore = true
    @Published public private(set) var errorMessage: String = ""
    @Published public var showErrorAlert: Bool = false
    
    private(set) var currentPage = 0
    private var cancellables: Set<AnyCancellable> = []
    private let usersListUseCase: UsersListUseCaseProtocol
    
    public init(usersListUseCase: UsersListUseCaseProtocol) {
        self.usersListUseCase = usersListUseCase
    }
    
    public func isLastItem(_ user: UserEntity) -> Bool {
        return user.id == users.last?.id
    }
    
    public func loadUsers() {
        loadUsersFromCache()
        fetchUsers()
    }
    
    private func loadUsersFromCache() {
        let cachedUsers = usersListUseCase.getCachedUsers()
        if !cachedUsers.isEmpty {
            self.users = cachedUsers
        }
    }
    
    public func fetchUsers() {
        guard !isLoading, hasLoadMore else { return }
        isLoading = true
        let since = currentPage * usersListUseCase.pageSize
        usersListUseCase.fetchUsers(since: since)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.handleCompletion(completion)
            } receiveValue: { [weak self] users in
                guard let self else { return }
                self.updateUsersList(users, since: since)
            }
            .store(in: &cancellables)
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        isLoading = false
        if case .failure(let error) = completion {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
    
    private func updateUsersList(_ newUsers: [UserEntity], since: Int) {
        let uniqueNewUsers = removeDuplicates(from: newUsers)
        
        if currentPage == 0 {
            self.users = uniqueNewUsers
        } else {
            let combinedUsers = users + uniqueNewUsers
            self.users = removeDuplicates(from: combinedUsers)
        }
        
        currentPage += 1
        hasLoadMore = !newUsers.isEmpty
    }
    
    private func removeDuplicates(from users: [UserEntity]) -> [UserEntity] {
        var seen = Set<String>()
        return users.filter { user in
            seen.insert(user.login).inserted
        }
    }
    
    public func refreshUsers() {
        currentPage = 0
        usersListUseCase.removeAllCached()
        fetchUsers()
    }
}
