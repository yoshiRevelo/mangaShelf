//
//  ReadingSnapshotStore.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 12/09/26.
//

import Foundation
import WidgetKit

enum ReadingSnapshotStore {
    private static let suiteName = "group.com.sample.MangaShelf"
    private static let key = "readingMangas"
    
    static func save(from items: [CollectionItem]) {
        print("Saving changes")
        guard let defaults = UserDefaults(suiteName: suiteName) else { return }
        
        let reading = items
            .filter { $0.readingVolume ?? 0 != $0.ownedVolumes }
            .sorted { $0.lastUpdated > $1.lastUpdated }
            .prefix(3)
            .map {
                ReadingManga(mangaID: $0.mangaID, title: $0.cachedTitle, readingVolume: $0.readingVolume ?? 0, ownedVolumes: $0.ownedVolumes)
            }
        
        if let data = try? JSONEncoder().encode(Array(reading)) {
            defaults.set(data, forKey: key)
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    static func load() -> [ReadingManga] {
        guard let defaults = UserDefaults(suiteName: suiteName),
              let data = defaults.data(forKey: key),
              let items = try? JSONDecoder().decode([ReadingManga].self, from: data) else { return [] }
        
        return items
    }
}
