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
    @State private var selectedDemographic: Demographic? = nil
    
    var demographicTitle: String {
        selectedDemographic?.rawValue.lowercased() ?? "all"
    }
    
    var body: some View {
        Group {
            if let viewModel {
                switch viewModel.listState {
                case .idle, .loading:
                    ContentUnavailableView {
                        VStack {
                            Label("Loading \(demographicTitle) mangas", systemImage: "apple.books.pages")
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
                viewModel = MangasListViewModel(repository: environment.mangaRepository)
            }
            await viewModel?.loadMangas()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("All") { selectedDemographic = nil }
                    ForEach(Demographic.allCases.filter { $0 != .other }) { demographic in
                        Button(demographic.rawValue) { selectedDemographic = demographic }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                .foregroundStyle(Color.accentColor)
                .onChange(of: selectedDemographic) {
                    Task {
                        if let selectedDemographic {
                            await viewModel?.selectMode(.demographic(selectedDemographic))
                        } else {
                            await viewModel?.selectMode(.all)
                        }
                    }
                }
            }
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
