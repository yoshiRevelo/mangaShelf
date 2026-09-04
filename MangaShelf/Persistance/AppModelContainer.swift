//
//  AppModelContainer.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 31/08/26.
//

import Foundation
import SwiftData

enum AppModelContainer {
    static let schema = Schema([
        CollectionItem.self
    ])
    
    static func live() -> ModelContainer {
        let config = ModelConfiguration(
            "CollectionManager",
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("No se puede crear el model container \(error)")
        }
    }
    
    static func preview() -> ModelContainer {
        let config = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true)
        
        do {
            let container = try ModelContainer(for: schema, configurations: [config])
            
            SampleData.seed(into: container.mainContext)
            
            return container
        } catch {
            fatalError("No se puede crear el model container \(error)")
        }
    }
}

