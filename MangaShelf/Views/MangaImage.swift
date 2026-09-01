//
//  MangaImage.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 29/08/26.
//

import SwiftUI

struct MangaImage: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url, transaction: Transaction(animation: .easeOut(duration: 0.25))) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .empty, .failure:
                placeholderImage()
            @unknown default:
                placeholderImage()
            }
        }
    }
    
    @ViewBuilder
    private func placeholderImage() -> some View {
        Image(systemName: "books.vertical.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.tertiary.opacity(0.3))
            .padding()
    }
}

#Preview {
    MangaImage(url: Manga.monster.mainPicture)
}
