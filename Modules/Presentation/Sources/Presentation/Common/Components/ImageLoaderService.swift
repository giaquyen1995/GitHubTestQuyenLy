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
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    deinit {
        cancelCurrentTask()
    }
    
    public func fetchImage(from url: URL) {
        cancelCurrentTask()
        cancellable = urlSession.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .receive(on: DispatchQueue.main)
            .replaceError(with: nil)
            .sink { [weak self] in self?.image = $0 }
    }
    
    private func cancelCurrentTask() {
        cancellable?.cancel()
        cancellable = nil
    }
}
