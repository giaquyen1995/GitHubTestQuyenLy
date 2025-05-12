//
//  UserDetailViewModel.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import Domain
import Combine

private enum Constants {
    static let maxFollowersDisplay = 100
}

public protocol UserDetailViewModelInput {
    func fetchUserDetails()
}

public protocol UserDetailViewModelOutput {
    var user: UserEntity? { get }
    var errorMessage: String { get }
    var showErrorAlert: Bool { get set }
    var followersCount: String { get }
    var followingCount: String { get }
    var isLoading: Bool { get }
}

public final class UserDetailViewModel: ObservableObject, UserDetailViewModelInput, UserDetailViewModelOutput {
    @Published private(set) var state: UserDetailState = .idle
    @Published public var showErrorAlert: Bool = false
    
    public var user: UserEntity? { state.user }
    public var errorMessage: String { state.errorMessage }
    public var isLoading: Bool { state.isLoading }
    
    public var followersCount: String {
        return UserDetailViewModel.formatFollow(for: user?.followers ?? 0)
    }
    
    public var followingCount: String {
        return UserDetailViewModel.formatFollow(for: user?.following ?? 0)
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private let userDetailUseCase: UserDetailUseCaseProtocol
    private let loginUserName: String
    
    public init(
        loginUserName: String,
        userDetailUseCase: UserDetailUseCaseProtocol
    ) {
        self.loginUserName = loginUserName
        self.userDetailUseCase = userDetailUseCase
    }
}

extension UserDetailViewModel {
    public func fetchUserDetails() {
        state = .loading
        userDetailUseCase.fetchUserDetails(loginUserName: loginUserName)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] in
                    self?.handleCompletion($0)
                },
                receiveValue: { [weak self] user in
                    self?.state = .loaded(user)
                }
            )
            .store(in: &cancellables)
    }
}

private extension UserDetailViewModel {
    func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        guard case .failure(let error) = completion else { return }
        state = .error(error.localizedDescription)
        showErrorAlert = true
    }
    
    static func formatFollow(for follow: Int, max: Int = Constants.maxFollowersDisplay) -> String {
        return follow > max ? "\(max)+" : "\(follow)"
    }
}
