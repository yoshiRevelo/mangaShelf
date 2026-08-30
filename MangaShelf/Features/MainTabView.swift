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
                MangasListScreen()
            }
            
            Tab(AppTab.collection.title, systemImage: AppTab.collection.symbol, value: AppTab.collection) {
                EmptyView()
            }
            
            Tab(AppTab.settings.title, systemImage: AppTab.settings.symbol, value: AppTab.settings) {
                EmptyView()
            }
            
            Tab(AppTab.search.title, systemImage: AppTab.search.symbol, value: AppTab.search, role: .search) {
                EmptyView()
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    MainTabView()
        .environment(AppRouter())
        .environment(AppEnvironment.preview())
}
