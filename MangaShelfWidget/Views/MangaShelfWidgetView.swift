//
//  MangaShelfWidgetView.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 12/09/26.
//

import SwiftUI
import WidgetKit

struct MangaShelfWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        Group {
            if entry.mangas.isEmpty {
                ContentUnavailableView("No mangas in progress", systemImage: "apple.books.pages")
                    .font(.caption)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reading")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                    
                    ForEach(entry.mangas) { manga in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(manga.title)
                                .font(.headline)
                                .lineLimit(1)
                            
                            CollectionInditatorView(readingVolume: manga.readingVolume, ownedVolumes: manga.ownedVolumes)
                        }
                    }
                }
                .padding()
            }
        }
        .widgetURL(URL(string: "mangashelf://collection"))
    }
}

#Preview(as: .systemMedium) {
    MangaShelfWidget()
} timeline: {
    ReadingEntry(date: .now, mangas: [
        ReadingManga(mangaID: 1, title: "Monster", readingVolume: 4, ownedVolumes: 9),
        ReadingManga(mangaID: 2, title: "Berserk", readingVolume: 12, ownedVolumes: 12)
    ])
}
