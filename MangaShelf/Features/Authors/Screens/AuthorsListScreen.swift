//
//  AuthorsListScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 05/09/26.
//

import SwiftUI

struct AuthorsListScreen: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var viewModel: AuthorsListViewModel?
    let onTap: (Author) -> Void
    
    var body: some View {
        Group {
            if let viewModel {
                switch viewModel.listState {
                case .idle, .loading:
                    ContentUnavailableView {
                        VStack {
                            Label("Loading authors", systemImage: "pencil.and.scribble")
                            ProgressView()
                                .tint(Color.accent)
                        }
                    }
                case .loaded, .loadMore:
                    content(viewModel)
                case .error(let message):
                    emptyState(viewModel, message: message)
                }
            } else {
                ProgressView()
            }
        }
        .task {
            if viewModel == nil {
                viewModel = AuthorsListViewModel(catalogRepository: environment.catalogRepository)
            }
            await viewModel?.loadAuthors()
        }
    }
    
    @ViewBuilder
    private func content(_ viewModel: AuthorsListViewModel) -> some View {
        let list = viewModel.authors
        
        List {
            ForEach(viewModel.authors) { author in
                Button(author.fullName) {
                    onTap(author)
                }
                .font(.headline)
                .fontWeight(.medium)
                .onAppear {
                    if author.id == list.last?.id {
                        Task { await viewModel.loadAuthors() }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func emptyState(_ viewModel: AuthorsListViewModel, message: String) -> some View {
        ContentUnavailableView {
            Label("No authors available", systemImage: "pencil.and.scribble")
        } description: {
            Text(message)
        } actions: {
            Button("Try again") {
                Task { await viewModel.loadAuthors() }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    AuthorsListScreen() { _ in }
        .environment(AppEnvironment.preview())
}
