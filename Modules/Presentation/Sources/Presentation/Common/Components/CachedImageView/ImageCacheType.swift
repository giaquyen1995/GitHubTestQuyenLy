//
//  ImageCacheType.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import UIKit

public protocol ImageCacheProtocol {
    func fetchImage(for url: URL) -> UIImage?
    func storeImage(_ image: UIImage, for url: URL, withExpiry expiry: TimeInterval)
}
