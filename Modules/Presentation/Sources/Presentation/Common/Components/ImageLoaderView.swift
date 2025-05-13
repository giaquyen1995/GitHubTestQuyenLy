//
//  ImageLoaderView.swift
//  Presentation
//
//  Created by QuyenLG on 10/5/25.
//
import SwiftUI

public struct ImageLoaderView: View {
    @ObservedObject private var imageLoader: ImageLoaderService
    
    private let url: URL?
    private let imageSize: CGFloat
    private let placeholderColor: Color
    
    public init(
        url: URL?,
        imageSize: CGFloat,
        imageLoader: ImageLoaderService? = nil,
        placeholderColor: Color = .gray.opacity(0.2)
    ) {
        self.url = url
        self.imageSize = imageSize
        self.placeholderColor = placeholderColor
        self.imageLoader = imageLoader ?? ImageLoaderService()
    }
}

public extension ImageLoaderView {
    var body: some View {
        Group {
            if let image = imageLoader.image {
                loadedImageView(image: image)
            } else {
                placeholderView
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }
}

private extension ImageLoaderView {
    @ViewBuilder
    private func loadedImageView(image: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: imageSize, height: imageSize)
            .clipShape(Circle())
    }
    
    private var placeholderView: some View {
        ProgressView()
            .frame(width: imageSize, height: imageSize)
            .background(
                Circle()
                    .fill(placeholderColor)
            )
    }
    
    @MainActor
    private func loadImage() async {
        guard let url = url else { return }
        imageLoader.fetchImage(from: url)
    }
}
