//
//  UserDetailView.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import SwiftUI

public struct UserDetailView: View {
    @ObservedObject private var viewModel: UserDetailViewModel
    @EnvironmentObject var router: Router
    
    public init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: PaddingConstants.large) {
            userProfileView
            userStatsView
            userBlogView
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            viewModel.fetchUserDetails()
        }
        .navigationTitle("User Details")
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.navigateBack()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    private var userProfileView: some View {
        UserProfileCardView(
            avatar: URL(string: viewModel.user?.avatarURL ?? ""),
            name: viewModel.user?.login ?? "",
            location: viewModel.user?.location ?? ""
        )
    }
    
    private var userStatsView: some View {
        HStack(spacing: 40) {
            UserStatView(
                iconName: "person.2.fill",
                countText: viewModel.followersCount,
                label: "Followers"
            )
            
            UserStatView(
                iconName: "person.2.circle.fill",
                countText: viewModel.followingCount,
                label: "Following"
            )
        }
    }
    
    private var userBlogView: some View {
        VStack(alignment: .leading, spacing: PaddingConstants.medium) {
            Text("Blog")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text(viewModel.user?.blog ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, PaddingConstants.large)
    }
}
