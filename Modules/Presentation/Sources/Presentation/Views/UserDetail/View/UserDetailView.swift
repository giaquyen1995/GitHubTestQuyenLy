//
//  UserDetailView.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import SwiftUI

public struct UserDetailView: View {
    @StateObject private var viewModel: UserDetailViewModel
    @EnvironmentObject var router: Router
    
    public init(viewModel: UserDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack(spacing: UIConstants.Padding.large) {
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
            avatar: viewModel.avatar,
            name: viewModel.name,
            location: viewModel.location
        )
    }
    
    private var userStatsView: some View {
        HStack(spacing: 40) {
            UserStatView(
                iconName: "person.2.fill",
                countText: "\(FollowCountFormatter.format(for: viewModel.followersCount))",
                label: "Followers"
            )
            
            UserStatView(
                iconName: "person.2.circle.fill",
                countText: "\(FollowCountFormatter.format(for: viewModel.followingCount))",
                label: "Following"
            )
        }
    }
    
    private var userBlogView: some View {
        VStack(alignment: .leading, spacing: UIConstants.Padding.medium) {
            Text("Blog")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
            
            Text(viewModel.blog)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, UIConstants.Padding.large)
    }
}
