//
//  MangaShelfApp.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 16/08/26.
//

import SwiftUI
import SwiftData

@main
struct MangaShelfApp: App {
    @State private var router = AppRouter()
    @State private var environment = AppEnvironment.live()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(environment)
                .environment(router)
                .task {
                    await environment.sessionStore.restore()
                }
        }
//    #if os(macOS)
//    .defaultSize(width: 1100, height: 700)
//    #endif
    }
}
