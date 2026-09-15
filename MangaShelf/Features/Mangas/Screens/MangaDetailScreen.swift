//
//  MangaDetailScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 29/08/26.
//

import Foundation
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
        @Bindable var router = router
        
        ScrollView {
            VStack(alignment: .leading, spacing: 8){
                MangaImage(url: manga.mainPicture)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .clipped()
                    .frame(maxWidth: .infinity, alignment: .center)
                
                if let score = manga.score {
                    ScoreView(score)
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
                
                HStack(spacing: 4) {
                    ForEach(Array(manga.genres.enumerated()), id: \.element.id) { index, genre in
                        if index > 0 {
                            Text("·")
                                .foregroundStyle(.secondary)
                        }
                        Text(genre.genre)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                
                if let volumesAndChaptersText {
                    Text(volumesAndChaptersText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
                
                
                Text(manga.status.title)
                    .font(.headline)
                    .foregroundStyle(manga.status.color)
                
                
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
                
                AppButton(title: collectionItem == nil ? String(localized: "Add to collection") : String(localized: "Edit item")) {
                    Task {
                        guard environment.sessionStore.isAuthenticated else {
                            router.toast = ToastMessage(String(localized: "Sign in to add to your collection"), kind: .error)
                            return
                        }
                        
                        if collectionItem == nil {
                            let item = CollectionItem(mangaID: manga.id, cachedTitle: manga.title, totalVolumes: manga.volumes)
                            do {
                                try await environment.collectionRepository.upsert(item)
                                collectionItem = item
                                router.toast = ToastMessage(String(localized: "Added to collection"), kind: .success)
                                router.collectionDidChange += 1
                                showCollectionItemScreen = true
                            } catch {
                                router.toast = ToastMessage((error as? APIError)?.errorDescription ?? error.localizedDescription, kind: .error)
                            }
                        } else {
                            showCollectionItemScreen = true
                        }
                    }
                }
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
                .padding(.top)
            }
        }
        .scrollIndicators(.hidden)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
        #endif
        .padding()
        .task(id: environment.sessionStore.isAuthenticated) {
            collectionItem = try? await environment.collectionRepository.fetchManga(mangaID: manga.id)
        }
        .sheet(item: $selectedManga) { selected in
            SynopsisScreen(title: selected.title, synopsis: selected.synopsis ?? "")
        }
        .sheet(isPresented: $showCollectionItemScreen) {
            if let collectionItem {
                NavigationStack {
                    CollectionItemScreen(collectionItem: collectionItem) {
                        router.collectionDidChange += 1
                    } onChange: {
                        self.collectionItem = nil
                    }
                }
                .toast($router.toast)
            }
        }
    }
    
    @ViewBuilder
    private func section<Content: View>(_ title: LocalizedStringKey, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title2)
                .fontWeight(.medium)
            
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func ScoreView(_ score: Decimal) -> some View {
        let scoreValue = NSDecimalNumber(decimal: score).doubleValue
        let filledStars = min(5, max(0, Int((scoreValue / 2).rounded())))
        
        if filledStars > 0 {
            HStack(spacing: 6) {
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        Image(systemName: "star")
                            .font(.title2)
                            .symbolVariant(.fill)
                            .foregroundStyle(index < filledStars ? .yellow : .secondary.opacity(0.5))
                            .padding(.top, 8)
                            .padding(.bottom, 8)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var volumesAndChaptersText: String? {
        let volumesText: String? = manga.volumes.map { count in
            count > 1
                ? String(localized: "\(count.formatted()) volumes")
                : String(localized: "\(count.formatted()) volume")
        }
        let chaptersText: String? = manga.chapters.map { count in
            count > 1
                ? String(localized: "\(count.formatted()) chapters")
                : String(localized: "\(count.formatted()) chapter")
        }
        let parts: [String] = [volumesText, chaptersText].compactMap { $0 }
        
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

#Preview("Naruto") {
    NavigationStack {
        MangaDetailScreen(manga: .naruto)
    }
    .environment(AppRouter())
    .environment(AppEnvironment.preview())
}
