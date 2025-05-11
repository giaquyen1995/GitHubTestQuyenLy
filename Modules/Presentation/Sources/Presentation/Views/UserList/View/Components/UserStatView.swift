//
//  StatInfoView.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import SwiftUI

public struct UserStatView: View {
    var iconName: String
    var countText: String
    var label: String
    
    public init(
        iconName: String,
        countText: String,
        label: String
    ) {
        self.iconName = iconName
        self.countText = countText
        self.label = label
    }
    
    public var body: some View {
        VStack(spacing: 6) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(
                        width: 40,
                        height: 40
                    )
                
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.primary)
            }
            
            Text(countText)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text(label)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}
