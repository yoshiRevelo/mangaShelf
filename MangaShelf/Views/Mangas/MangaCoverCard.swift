//
//  MangaCoverCard.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 28/08/26.
//

import SwiftUI

struct MangaCoverCard: View {
    let manga: Manga
    var readingProgress: Double? = nil
    var isComplete = false
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Color.clear
                    .aspectRatio(3/4, contentMode: .fit)
                    .overlay {
                        MangaImage(url: manga.mainPicture)
                    }
                    .clipped()
                
                    .overlay(alignment: .topTrailing) {
                        HStack(spacing: 5) {
                            Image(systemName: "star")
                                .symbolVariant(.fill)
                            if let score = manga.score?.toString {
                                Text(score)
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.vertical, 6)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .background(.black.opacity(0.5))
                        .clipShape(.capsule)
                        .padding(.top, 8)
                        .padding(.trailing, 8)
                    }
                    .overlay(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(manga.title)
                                .font(.title3)
                                .foregroundStyle(.ink)
                                .fontWeight(.bold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .padding(.top, 8)
                                .frame(maxHeight: 60)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .background(.white.opacity(0.7))
                    }
            }
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
        }
        .buttonStyle(PressableCardStyle())
    }
}

#Preview {
    MangaCoverCard(manga: .berserk, readingProgress: 0.6, onTap: { })
        .frame(width: 200)
}
