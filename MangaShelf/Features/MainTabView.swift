//
//  MainTabView.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 16/08/26.
//

import SwiftUI

struct MainTabView: View {
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
                ContentUnavailableView("This feature will be available soon.", systemImage: AppTab.settings.symbol)
                    .foregroundStyle(.warning)
            }
            
            Tab(AppTab.search.title, systemImage: AppTab.search.symbol, value: AppTab.search, role: .search) {
                ContentUnavailableView("This feature will be available soon.", systemImage: AppTab.search.symbol)
                    .foregroundStyle(.warning)
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    MainTabView()
        .environment(AppRouter())
        .environment(AppEnvironment.preview())
}
