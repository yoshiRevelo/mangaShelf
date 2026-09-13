//
//  MangaShelfWidget.swift
//  MangaShelfWidget
//
//  Created by Josimar Revelo on 12/09/26.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    typealias Entry = ReadingEntry
    
    func placeholder(in context: Context) -> ReadingEntry {
        ReadingEntry(date: Date(), mangas: [
            ReadingManga(mangaID: 1, title: "Monster", readingVolume: 4, ownedVolumes: 9)
        ])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ReadingEntry) -> Void) {
        completion(ReadingEntry(date: Date(), mangas: ReadingSnapshotStore.load()))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = ReadingEntry(date: Date(), mangas: ReadingSnapshotStore.load())
        completion(Timeline(entries: [entry], policy: .never))
    }
}
