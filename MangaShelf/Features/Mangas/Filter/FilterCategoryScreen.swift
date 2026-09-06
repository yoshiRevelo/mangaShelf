//
//  FilterCategoryScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 05/09/26.
//

import SwiftUI

struct FilterCategoryScreen: View {
    @Environment(\.dismiss) private var dismiss
    let category: FilterCategory
    let viewModel: MangasListViewModel?
    @Binding var searchTitle: String
    
    private var navTitle: String {
        category != .authors ? "Select a \(category.name.lowercased())" : "Select an \(category.name.lowercased())"
    }
    
    var body: some View {
        if let viewModel {
            NavigationStack {
                Group {
                    switch category {
                    case .genre:
                        List {
                            ForEach(viewModel.genres, id: \.self) { genre in
                                Button(genre) {
                                    searchTitle = genre
                                    dismiss()
                                    Task {
                                        await viewModel.selectMode(.genre(genre))
                                    }
                                }
                                .font(.headline)
                                .fontWeight(.medium)
                            }
                        }
                    case .themes:
                        List {
                            ForEach(viewModel.themes, id: \.self) { theme in
                                Button(theme) {
                                    searchTitle = theme
                                    dismiss()
                                    Task {
                                        await viewModel.selectMode(.theme(theme))
                                    }
                                }
                                .font(.headline)
                                .fontWeight(.medium)
                            }
                        }
                        
                    case .demographic:
                        List {
                            ForEach(viewModel.demographics) { demographic in
                                Button(demographic.rawValue) {
                                    searchTitle = demographic.rawValue
                                    dismiss()
                                    Task {
                                        await viewModel.selectMode(.demographic(demographic))
                                    }
                                }
                                .font(.headline)
                                .fontWeight(.medium)
                            }
                        }
                    case .authors:
                        AuthorsListScreen { author in
                            searchTitle = author.fullName
                            dismiss()
                            Task { await viewModel.selectMode(.author(author.id)) }
                        }
                    }
                }
                .navigationTitle(navTitle)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

//#Preview {
//    @Previewable @State var searchTitle = "All"
//    FilterCategoryScreen(
//        category: .genre,
//        viewModel: MangasListViewModel(
//            repository: AppEnvironment.preview().mangaRepository,
//            catalogRepository: AppEnvironment.preview().catalogRepository
//        ),
//        searchTitle: $searchTitle
//    )
//}
