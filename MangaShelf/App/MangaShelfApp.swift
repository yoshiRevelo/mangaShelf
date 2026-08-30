//
//  MangaShelfApp.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 16/08/26.
//

import SwiftUI

@main
struct MangaShelfApp: App {
    @State private var router = AppRouter()
    @State private var environment = AppEnvironment.live()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .transition(.opacity)
                .environment(environment)
                .environment(router)
        }
    }
}
