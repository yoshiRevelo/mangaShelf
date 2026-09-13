//
//  ReadingEntry.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 12/09/26.
//
import Foundation
import SwiftUI
import WidgetKit

struct ReadingEntry: TimelineEntry, Sendable {
    let date: Date
    let mangas: [ReadingManga]
}

struct MangaShelfWidget: Widget {
    let kind: String = "MangaShelfWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MangaShelfWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Reading now")
        .description("Shows the mangas you're currently reading and your progress.")
        .supportedFamilies([.systemSmall, .systemMedium])
        
    }
}
