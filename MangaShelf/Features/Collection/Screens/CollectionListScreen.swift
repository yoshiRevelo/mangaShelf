//
//  CollectionListScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 02/09/26.
//

import SwiftUI

struct CollectionListScreen: View {
    @Environment(AppEnvironment.self) private var environment
    
    @State private var viewModel: CollectionListViewModel?
    @State private var selectedItem: CollectionItem?
    
    var body: some View {
        NavigationSplitView {
            Group {
                if let viewModel {
                    switch viewModel.listState {
                    case .idle, .loading:
                        ProgressView()
                    case .loaded, .loadMore:
                        content(viewModel)
                    case .error(let message):
                        emptyState(viewModel, message: message)
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle(AppTab.collection.title)
            .toolbar(removing: .sidebarToggle)
            .toolbar(removing: .title)
        } detail: {
            if let selectedItem {
                CollectionItemScreen(collectionItem: selectedItem) { } onChange: {
                    self.selectedItem = nil
                    Task { await viewModel?.loadCollection() }
                }
            } else {
                ContentUnavailableView("Select an item from your collection", systemImage: "bookmark")
            }
        }
        .task {
            if viewModel == nil {
                viewModel = CollectionListViewModel(repository: environment.collectionRepository)
            }
            await viewModel?.loadCollection()
        }
    }
    
    @ViewBuilder
    private func content(_ viewModel: CollectionListViewModel) -> some View {
        @Bindable var viewModel = viewModel
        
        let items = viewModel.filteredItems
        
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
    }
    
    @ViewBuilder
    private func emptyState(_ viewModel: CollectionListViewModel, message: String) -> some View {
        ContentUnavailableView {
            Label("No mangas available", systemImage: "apple.books.pages")
        } description: {
            Text(message)
        } actions: {
            Button("Try again") {
                Task { await viewModel.loadCollection() }
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
