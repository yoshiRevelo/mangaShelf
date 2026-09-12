//
//  MainTabView.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 16/08/26.
//

import SwiftUI

struct MainTabView: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        @Bindable var router = router
        
        TabView(selection: $router.selectedTab) {
            Tab(AppTab.list.title, systemImage: AppTab.list.symbol, value: AppTab.list) {
                NavigationStack(path: $router.listPath) {
                    MangasListScreen()
                        .navigationDestination(for: MangaRoute.self) { route in
                            switch route {
                            case .detail(let manga):
                                MangaDetailScreen(manga: manga)
                            }
                        }
                }
            }
            
            Tab(AppTab.collection.title, systemImage: AppTab.collection.symbol, value: AppTab.collection) {
                CollectionListScreen()
            }
            
            Tab(AppTab.settings.title, systemImage: AppTab.settings.symbol, value: AppTab.settings) {
                NavigationStack {
                    if !environment.sessionStore.isAuthenticated {
                        AuthScreen()
                    } else {
                        if let currentUser =  environment.sessionStore.currentUser {
                            SettingsScreen(user: currentUser)
                        }
                    }
                }
            }
            
            Tab(AppTab.search.title, systemImage: AppTab.search.symbol, value: AppTab.search, role: .search) {
                ContentUnavailableView("This feature will be available soon.", systemImage: AppTab.search.symbol)
                    .foregroundStyle(.warning)
            }
        }
        #if os(iOS)
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewStyle(.sidebarAdaptable)
        #endif
        .toast($router.toast)
    }
}

#Preview {
    MainTabView()
        .environment(AppRouter())
        .environment(AppEnvironment.preview())
}
