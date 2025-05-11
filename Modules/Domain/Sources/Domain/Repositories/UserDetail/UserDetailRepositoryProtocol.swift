//
//  Untitled.swift
//  Domain
//
//  Created by QuyenLG on 11/5/25.
//

import Foundation
import Combine

public protocol UserDetailRepositoryProtocol {
    func fetchUserDetail(loginUserName: String) -> AnyPublisher<UserEntity, Error>
}
