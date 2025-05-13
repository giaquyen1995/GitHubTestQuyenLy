//
//  UsersListView.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import SwiftUI
import Domain
import Data

public struct UsersListView: View {
    @EnvironmentObject var router: Router
    @ObservedObject private var viewModel: UsersListViewModel
    
    public init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        List {
            usersList
            loadingIndicator
        }
        .listStyle(.plain)
        .navigationTitle("Github Users")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadUsers)
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
        .refreshable {
            viewModel.refreshUsers()
        }
    }
    
}

private extension UsersListView {
    private var usersList: some View {
        ForEach(viewModel.users) { user in
            UserProfileCardView(
                avatar: URL(string: user.avatarURL),
                name: user.login,
                link: user.htmlURL
            )
            .listStyle(PlainListStyle())
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .onAppear {
                loadMoreIfNeeded(for: user)
            }
            .onTapGesture {
                navigateToUserDetail(user)
            }
        }
    }
    
    private var loadingIndicator: some View {
        Group {
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .frame(height: 50)
                    Spacer()
                }
            }
        }
    }
    
    private func loadUsers() {
        if viewModel.users.isEmpty {
            viewModel.loadUsers()
        }
    }
    
    private func loadMoreIfNeeded(for user: UserEntity) {
        if viewModel.isLastItem(user) {
            viewModel.fetchUsers()
        }
    }
    
    private func navigateToUserDetail(_ user: UserEntity) {
        router.navigate(to: .userDetail(loginUserName: user.login))
    }
}
