//
//  MangasListScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 29/08/26.
//

import SwiftUI

struct MangasListScreen: View {
    @Environment(AppRouter.self) private var router
    @Environment(AppEnvironment.self) private var environment
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var viewModel: MangasListViewModel?
    @State private var filterCategory: FilterCategory?
    @State private var searchTitle: String = "all"
    
    var body: some View {
        Group {
            if let viewModel {
                switch viewModel.listState {
                case .idle, .loading:
                    ContentUnavailableView {
                        VStack {
                            Label("Loading \(searchTitle.lowercased()) mangas", systemImage: "apple.books.pages")
                            ProgressView()
                                .tint(Color.accent)
                        }
                    }
                case .loaded, .loadMore:
                    content(viewModel)
                        .padding()
                case .error(let message):
                    emptyState(viewModel, message: message)
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle(AppTab.list.title)
        .task {
            if viewModel == nil {
                viewModel = MangasListViewModel(repository: environment.mangaRepository, catalogRepository: environment.catalogRepository)
            }
            async let mangasLoad = viewModel?.loadMangas()
            async let catalogLoad = viewModel?.loadCatalogIfNeeded()
            await mangasLoad
            await catalogLoad
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("All") {
                        filterCategory = nil
                        searchTitle = "all"
                        Task {
                            await viewModel?.selectMode(.all)
                        }
                    }
                    Button(FilterCategory.genre.name) { filterCategory = .genre }
                    Button(FilterCategory.themes.name) { filterCategory = .themes }
                    Button(FilterCategory.demographic.name) { filterCategory = .demographic }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                .foregroundStyle(Color.accentColor)
            }
        }
        .sheet(item: $filterCategory) { category in
            FilterCategoryScreen(category: category, viewModel: viewModel, searchTitle: $searchTitle)
        }
    }
    
    @ViewBuilder
    private func content(_ viewModel: MangasListViewModel) -> some View {
        let list = viewModel.mangas
        
        var columns: [GridItem] {
            let minimum: CGFloat = horizontalSizeClass == .compact ? 120 : 190
            let maximum: CGFloat = horizontalSizeClass == .compact ? 170 : 270
            return [GridItem(.adaptive(minimum: minimum, maximum: maximum), spacing: 12)]
        }
        
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(list) { manga in
                    MangaCoverCard(manga: manga, onTap: { router.openDetailFromList(manga) })
                        .onAppear {
                            if manga.id == list.last?.id {
                                Task { await viewModel.loadMangas() }
                            }
                        }
                }
            }
            
            if viewModel.listState.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    @ViewBuilder
    private func emptyState(_ viewModel: MangasListViewModel, message: String) -> some View {
        ContentUnavailableView {
            Label("No mangas available", systemImage: "apple.books.pages")
        } description: {
            Text(message)
        } actions: {
            Button("Try again") {
                Task { await viewModel.loadMangas() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview("With data") {
    NavigationStack {
        MangasListScreen()
    }
    .environment(AppEnvironment.preview())
    .environment(AppRouter())
}

#Preview("Error") {
    MangasListScreen()
        .environment(AppEnvironment.failPreview())
        .environment(AppRouter())
}
