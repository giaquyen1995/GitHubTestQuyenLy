//
//  ImageLoader.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//

import SwiftUI
import Combine

public final class ImageLoaderService: ObservableObject {
    @Published public var image: UIImage?
    
    private var cancellable: AnyCancellable?
    private let cacheManager: ImageCacheManager
    private let urlSession: URLSession
    private let cacheDuration: TimeInterval
    
    public init(
        cacheManager: ImageCacheManager = ImageCacheManager.shared,
        urlSession: URLSession = .shared,
        cacheDuration: TimeInterval = 5 * 60 // 5 minutes
    ) {
        self.cacheManager = cacheManager
        self.urlSession = urlSession
        self.cacheDuration = cacheDuration
    }
    
    public func fetchImage(from url: URL) {
        if let cachedImage = cacheManager.fetchImage(for: url) {
            self.image = cachedImage
            return
        }
        
        cancellable = urlSession.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .handleEvents(receiveOutput: { [weak self] image in
                if let image = image {
                    self?.cacheManager.storeImage(image, for: url, withExpiry: self?.cacheDuration ?? 86400)
                }
            })
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .sink { [weak self] in self?.image = $0 }
    }
}
