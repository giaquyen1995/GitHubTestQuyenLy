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
    var errorMessage: String { get }
    var showErrorAlert: Bool { get set }
}

public final class UsersListViewModel: ObservableObject, UsersListViewModelInput, UsersListViewModelOutput {
    @Published private(set) var state: UsersListState = .idle
    @Published public var showErrorAlert: Bool = false
    @Published public private(set) var hasLoadMore = true
    
    private(set) var currentPage = 0
    private var cancellables: Set<AnyCancellable> = []
    private let usersListUseCase: UsersListUseCaseProtocol
    
    public var users: [UserEntity] { state.users }
    public var isLoading: Bool { state.isLoading }
    public var errorMessage: String { state.errorMessage }
    
    public init(usersListUseCase: UsersListUseCaseProtocol) {
        self.usersListUseCase = usersListUseCase
    }
}

extension UsersListViewModel {
    public func isLastItem(_ user: UserEntity) -> Bool {
        return user.id == users.last?.id
    }
    
    public func loadUsers() {
        loadUsersFromCache()
        fetchUsers()
    }
    
    public func refreshUsers() {
        currentPage = 0
        state = .refresh
        usersListUseCase.removeAllCached()
        fetchUsers()
    }
    
    public func fetchUsers() {
        guard !isLoading, hasLoadMore else { return }
        state = currentPage == 0 ? .loading : .loadMore(self.users)
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
}

private extension UsersListViewModel {
    func loadUsersFromCache() {
        let cachedUsers = usersListUseCase.getCachedUsers()
        if !cachedUsers.isEmpty {
            self.state = .loaded(cachedUsers)
        }
    }
    
    func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        if case .failure(let error) = completion {
            state = .error(error.localizedDescription)
            showErrorAlert = true
        }
    }
    
    func updateUsersList(_ newUsers: [UserEntity], since: Int) {
        let uniqueNewUsers = removeDuplicates(from: newUsers)
        
        let updatedUsers: [UserEntity]
        if currentPage == 0 {
            updatedUsers = uniqueNewUsers
        } else {
            let combinedUsers = users + uniqueNewUsers
            updatedUsers = removeDuplicates(from: combinedUsers)
        }
        
        state = .loaded(updatedUsers)
        currentPage += 1
        hasLoadMore = !newUsers.isEmpty
    }
    
    func removeDuplicates(from users: [UserEntity]) -> [UserEntity] {
        var seen = Set<String>()
        return users.filter { user in
            seen.insert(user.login).inserted
        }
    }
}
