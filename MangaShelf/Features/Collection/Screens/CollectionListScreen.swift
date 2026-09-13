//
//  CollectionListScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 02/09/26.
//

import SwiftUI

struct CollectionListScreen: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(AppRouter.self) private var router
    
    @State private var viewModel: CollectionListViewModel?
    @State private var selectedItem: CollectionItem?
    
    var body: some View {
        NavigationSplitView {
            Group {
                if !environment.sessionStore.isAuthenticated {
                    ContentUnavailableView {
                        Label("Sign in", systemImage: "person.circle")
                    } description: {
                        Text("To view this section sign in first")
                    } actions: {
                        Button("Go to account") {
                            router.selectedTab = .account
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                        if let viewModel {
                            switch viewModel.listState {
                            case .idle, .loading:
                                ProgressView()
                            case .loaded, .loadMore:
                                content(viewModel)
                            case .error(let message):
                                errorState(viewModel, message: message)
                            }
                        } else {
                            ProgressView()
                        }
                    }
                }
            .navigationTitle(AppTab.collection.title)
            .toolbar(removing: .sidebarToggle)
            .toolbar(removing: .title)
            .navigationSplitViewColumnWidth(min: 240, ideal: 280, max: 320)
            } detail: {
            if let selectedItem {
                CollectionItemScreen(collectionItem: selectedItem, dismissesOnSave: false) {
                    router.collectionDidChange += 1
                } onChange: {
                    self.selectedItem = nil
                    Task { await viewModel?.loadCollection() }
                }
                .id(selectedItem.mangaID)
            } else {
                ContentUnavailableView("Select an item from your collection", systemImage: "bookmark")
            }
        }
        .task(id: environment.sessionStore.isAuthenticated) {
            selectedItem = nil
            guard environment.sessionStore.isAuthenticated else { return }
            if viewModel == nil {
                viewModel = CollectionListViewModel(repository: environment.collectionRepository)
            }
            if viewModel?.listState.loaded?.isEmpty ?? true {
                await viewModel?.loadCollection()
            }
        }
        .task(id: router.collectionDidChange) {
            await viewModel?.loadCollection()
        }
    }
    
    @ViewBuilder
    private func content(_ viewModel: CollectionListViewModel) -> some View {
        @Bindable var viewModel = viewModel
        
        let items = viewModel.filteredItems
        
        if items.isEmpty && viewModel.filter == .all {
            emptyState(viewModel, message: String(localized: "Add a new manga"))
        } else {
            List(selection: $selectedItem) {
                Section {
                    Picker("Filter", selection: $viewModel.filter) {
                        ForEach(CollectionFilter.allCases) { filter in
                            Text(filter.description)
                                .tag(filter)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Reading Status")
                }
                
                Section {
                    ForEach(items) { item in
                        RowCollectionItemView(collectionItem: item, onToggleComplete: {
                            Task { await viewModel.toggleComplete(manga: item) }
                        })
                        .tag(item)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deleteItem(manga: item)
                                    selectedItem = nil
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                                    .labelStyle(.iconOnly)
                            }
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.loadCollection()
            }
            .onChange(of: router.widgetMangaID) {
                guard let mangaID = router.widgetMangaID else { return }
                selectedItem = viewModel.filteredItems.first(where: { $0.mangaID == mangaID })
                router.widgetMangaID = nil
            }
        }
    }
    
    @ViewBuilder
    private func errorState(_ viewModel: CollectionListViewModel, message: String) -> some View {
        ContentUnavailableView {
            Label("Something went wrong", systemImage: "xmark.circle")
        } description: {
            Text(message)
        } actions: {
            Button("Try again") {
                Task { await viewModel.loadCollection() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    @ViewBuilder
    private func emptyState(_ viewModel: CollectionListViewModel, message: String) -> some View {
        ContentUnavailableView {
            Label("Your collection is empty", systemImage: "apple.books.pages")
        } description: {
            Text(message)
        } actions: {
            Button("Go to mangas") {
                router.selectedTab = .list
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    CollectionListScreen()
    .environment(AppEnvironment.preview())
    .environment(AppRouter())
}

#Preview("Error") {
    CollectionListScreen()
    .environment(AppEnvironment.failPreview())
    .environment(AppRouter())
}
