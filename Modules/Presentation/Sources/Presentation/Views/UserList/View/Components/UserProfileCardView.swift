//
//  UserListItemView.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import SwiftUI

public struct UserProfileCardView: View {
    let avatar: URL?
    let name: String
    let link: String?
    let location: String?
    
    public init(
        avatar: URL? = nil,
        name: String,
        link: String? = nil,
        location: String? = nil
    ) {
        self.avatar = avatar
        self.name = name
        self.link = link
        self.location = location
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: PaddingConstants.large) {
            profileImageView
            profileDetailsView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(CornerRadiusConstants.small)
        .modifier(CustomShadowView(shadowColor: .black.opacity(0.3), shadowRadius: 3.0))
        .padding(.horizontal, PaddingConstants.large)
        .padding(.vertical, PaddingConstants.medium)
    }
   
}

private extension UserProfileCardView {
    private var profileImageView: some View {
        ImageLoaderView(url: avatar, imageSize: 80)
            .padding(PaddingConstants.small)
            .background(.gray.opacity(0.08))
            .cornerRadius(CornerRadiusConstants.small)
            .padding([.top, .leading, .bottom], PaddingConstants.large)
    }
    
    private var profileDetailsView: some View {
        VStack(alignment: .leading, spacing: PaddingConstants.medium) {
            Text(name)
                .font(.headline)
            Divider()
            if let link {
                hyperlinkView(for: link)
            }
            
            if let location {
                locationView(locationName: location)
            }
        }
        .padding([.top, .trailing, .bottom], PaddingConstants.large)
    }
    
    private func hyperlinkView(for link: String) -> some View {
        Text(link)
            .foregroundColor(.blue.opacity(0.5))
            .underline()
            .onTapGesture {
                guard let url = URL(string: link) else { return }
                UIApplication.shared.open(url)
            }
    }
    
    private func locationView(locationName: String) -> some View {
        HStack(spacing: PaddingConstants.medium) {
            Image(systemName: "location.fill")
                .font(.subheadline)
            
            Text(locationName)
                .font(.subheadline)
        }
        .foregroundColor(.gray)
    }
}
