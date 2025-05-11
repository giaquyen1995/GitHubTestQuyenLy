//
//  Untitled.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

struct FollowCountFormatter {
    static func format(for follow: Int, max: Int = 100) -> String {
        return follow > max ? "\(max)+" : "\(follow)"
    }
}
