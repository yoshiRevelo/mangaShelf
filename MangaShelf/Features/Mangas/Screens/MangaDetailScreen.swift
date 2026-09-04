//
//  MangaDetailScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 29/08/26.
//

import SwiftUI

struct MangaDetailScreen: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(AppRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedManga: Manga?
    @State private var collectionItem: CollectionItem?
    @State private var showCollectionItemScreen = false
    
    let manga: Manga
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8){
                MangaImage(url: manga.mainPicture)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .clipped()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if let score = manga.score {
                    HStack {
                        Text(score.toString)
                            .font(.largeTitle)
                            .fontWeight(.medium)
                        Image(systemName: "star")
                            .symbolVariant(.fill)
                    }
                    .foregroundStyle(.yellow)
                    .frame(maxWidth: .infinity)
                }
                
                Text(manga.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading) {
                    ForEach(manga.authors) { author in
                        Text("\(author.authorInformation)")
                            .font(.headline)
                    }
                }
                .offset(y: -10)
                
                if let volumesAndChaptersText {
                    Text(volumesAndChaptersText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                
                
                Text(manga.status.title)
                    .font(.headline)
                    .foregroundStyle(manga.status.color)
                
                HStack {
                    FlowLayout {
                        ForEach(manga.genres) { genre in
                            ChipView(title: genre.genre, small: true, color: .secondary, action: {})
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if let resume = manga.synopsis {
                    section("Synopsis") {
                        VStack(alignment: .leading) {
                            Text(resume)
                                .font(.body)
                                .lineLimit(8)
                            Button("Read more") {
                                selectedManga = manga
                            }
                        }
                    }
                }
                
                
                section(manga.themes.count > 1 ? "Themes" : "Theme") {
                    FlowLayout {
                        ForEach(manga.themes) { theme in
                            ChipView(title: theme.theme, action: {})
                        }
                    }
                }
                
                section(manga.demographics.count > 1 ? "Demographics" : "Demographic") {
                    FlowLayout {
                        ForEach(manga.demographics) { demographic in
                            ChipView(title: demographic.rawValue, action: {})
                        }
                    }
                }
                
                AppButton(title: collectionItem == nil ? "Add to collection" : "Edit item") {
                    Task {
                        if collectionItem == nil {
                            let item = CollectionItem(mangaID: manga.id, cachedTitle: manga.title, totalVolumes: manga.volumes)
                            try await environment.collectionRepository.upsert(item)
                            collectionItem = item
                            showCollectionItemScreen = true
                        } else {
                            showCollectionItemScreen = true
                        }
                    }
                }
                .padding(.top)
            }
        }
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        .padding()
        .task {
            collectionItem = try? await environment.collectionRepository.fetchManga(mangaID: manga.id)
        }
        .sheet(item: $selectedManga) { selected in
            SynopsisScreen(title: selected.title, synopsis: selected.synopsis ?? "")
        }
        .sheet(isPresented: $showCollectionItemScreen) {
            if let collectionItem {
                NavigationStack {
                    CollectionItemScreen(collectionItem: collectionItem) { } onChange: {
                        self.collectionItem = nil
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
            
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var volumesAndChaptersText: String? {
        let parts: [String] = [
            manga.volumes.map { "\($0.formatted()) \($0 > 1 ? "tomos" : "tomo")" },
            manga.chapters.map { "\($0.formatted()) \($0 > 1 ? "capítulos" : "capítulo")" }
        ].compactMap { $0 }
        
        return parts.isEmpty ? nil : parts.joined(separator: " | ")
    }
}

#Preview {
    NavigationStack {
        MangaDetailScreen(manga: .monster)
    }
    .environment(AppRouter())
    .environment(AppEnvironment.preview())
}
