//
//  UsersListViewModel.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import Domain
import Combine

public final class UsersListViewModel: ObservableObject {
    @Published private(set) var users: [UserEntity] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasLoadMore = true
    @Published private(set) var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false
    
    private(set) var currentPage = 0
    private var cancellables: Set<AnyCancellable> = []
    private let usersListUseCase: UsersListUseCaseProtocol
    
    public init(usersListUseCase: UsersListUseCaseProtocol) {
        self.usersListUseCase = usersListUseCase
    }
    
    func isLastItem(_ user: UserEntity) -> Bool {
        return user.id == users.last?.id
    }
    
    func loadUsers() {
        loadUsersFromCache()
        fetchUsers()
    }
    
    private func loadUsersFromCache() {
        let cachedUsers = usersListUseCase.getCachedUsers()
        if !cachedUsers.isEmpty {
            self.users = cachedUsers
        }
    }
    
    func fetchUsers() {
        guard !isLoading, hasLoadMore else { return }
        isLoading = true
        let since = currentPage * usersListUseCase.pagingConfiguration.pageSize
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
    
    private func updateUsersList(_ users: [UserEntity], since: Int) {
        if currentPage == 0 {
            self.users = users
        } else {
            self.users.append(contentsOf: users)
        }
        currentPage += 1
        hasLoadMore = !users.isEmpty
    }
    
    func refreshUsers() {
        currentPage = 0
        users.removeAll()
        fetchUsers()
    }
}
