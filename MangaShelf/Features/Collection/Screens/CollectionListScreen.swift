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
        
        List {
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
                    NavigationLink(value: item) {
                        RowCollectionItemView(collectionItem: item, onToggleComplete: {
                            Task { await viewModel.toggleComplete(manga: item) }
                        })
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteItem(manga: item)
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
        .navigationDestination(for: CollectionItem.self) { item in
            CollectionItemScreen(collectionItem: item) {
                Task { await viewModel.loadCollection() }
            } onChange: {
                Task { await viewModel.loadCollection() }
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
    NavigationStack {
        CollectionListScreen()
    }
    .environment(AppEnvironment.preview())
    .environment(AppRouter())
}
