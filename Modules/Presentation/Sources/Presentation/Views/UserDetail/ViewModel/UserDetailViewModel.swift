//
//  Untitled.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import Foundation
import Domain
import Combine

public final class UserDetailViewModel: ObservableObject {
    @Published private(set) var user: UserEntity?
    @Published private(set) var errorMessage: String = ""
    @Published var showErrorAlert: Bool = false
    
    var followersCount: String {
        return formatFollow(for: user?.followers ?? 0)
    }
    
    var followingCount: String {
        return formatFollow(for: user?.following ?? 0)
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private let userDetailUseCase: UserDetailUseCaseProtocol
    let loginUserName: String
    
    public init(
        loginUserName: String,
        userDetailUseCase: UserDetailUseCaseProtocol
    ) {
        self.loginUserName = loginUserName
        self.userDetailUseCase = userDetailUseCase
    }
    
    func fetchUserDetails() {
        userDetailUseCase.fetchUserDetails(loginUserName: loginUserName)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
    
    private func formatFollow(for follow: Int, max: Int = 100) -> String {
        return follow > max ? "\(max)+" : "\(follow)"
    }
}
