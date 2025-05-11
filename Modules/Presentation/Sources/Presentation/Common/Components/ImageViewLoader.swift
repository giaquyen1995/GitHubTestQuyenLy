//
//  CachedAsyncImageView.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//
import SwiftUI

public struct ImageViewLoader: View {
    @StateObject private var imageLoader: ImageLoaderService
    
    let url: URL?
    let imageSize: CGFloat
    
    public init(
        url: URL?,
        imageSize: CGFloat,
        imageLoader: ImageLoaderService? = nil
    ) {
        self.url = url
        self.imageSize = imageSize
        _imageLoader = StateObject(wrappedValue: imageLoader ?? ImageLoaderService())
    }
    
    public var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(Circle())
            } else {
                ProgressView()
                    .frame(width: imageSize, height: imageSize)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            }
        }
        .task(id: url) {
            if let url = url {
                imageLoader.fetchImage(from: url)
            }
        }
    }
}
