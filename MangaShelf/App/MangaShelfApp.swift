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
                .onOpenURL { url in
                    router.selectedTab = .collection
                    if url.host == "collection" {
                        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                           let idString = components.queryItems?.first( where: { $0.name == "mangaID" })?.value,
                           let mangaID = Int(idString) {
                            router.widgetMangaID = mangaID
                        }
                    }
                }
                .task {
                    await environment.sessionStore.restore()
                }
        }
//    #if os(macOS)
//    .defaultSize(width: 1100, height: 700)
//    #endif
    }
}
