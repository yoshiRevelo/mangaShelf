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
    
    var body: some View {
            ZStack {
                Color.clear
                    .aspectRatio(3/4, contentMode: .fit)
                    .overlay {
                        AsyncImage(url: manga.mainPicture) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(systemName: "books.vertical.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            @unknown default:
                                Image(systemName: "books.vertical.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            }
                        }
                    }
                    .clipped()
                
                    .overlay(alignment: .topTrailing) {
                        HStack(spacing: 5) {
                            Image(systemName: "star")
                                .symbolVariant(.fill)
                            Text("8.4")
                                .font(.headline)
                                .fontWeight(.bold)
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
                            .fontWeight(.bold)
                            .padding(.top, 8)
                            
                            
                            if let readingProgress {
                                
                                ProgressView(value: readingProgress)
                                    .tint(isComplete ? .success : .accent)
                                
                                Text("Tomo 68 de 106")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
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
}

#Preview {
    MangaCoverCard(manga: .berserk, readingProgress: 0.6)
        .frame(width: 200)
}
