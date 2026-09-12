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
                                Button {
                                    searchTitle = genre
                                    dismiss()
                                    Task {
                                        await viewModel.selectMode(.genre(genre))
                                    }
                                } label: {
                                    Text(genre)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                }
                                .font(.headline)
                                .fontWeight(.medium)
                            }
                        }
                    case .themes:
                        List {
                            ForEach(viewModel.themes, id: \.self) { theme in
                                Button {
                                    searchTitle = theme
                                    dismiss()
                                    Task {
                                        await viewModel.selectMode(.theme(theme))
                                    }
                                } label: {
                                    Text(theme)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                }
                                .font(.headline)
                                .fontWeight(.medium)
                            }
                        }
                        
                    case .demographic:
                        List {
                            ForEach(viewModel.demographics) { demographic in
                                Button {
                                    searchTitle = demographic.rawValue
                                    dismiss()
                                    Task {
                                        await viewModel.selectMode(.demographic(demographic))
                                    }
                                } label: {
                                    Text(demographic.rawValue)
                                        .font(.headline)
                                        .fontWeight(.medium)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
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
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel) {
                            dismiss()
                        } label: {
                            Label("Close", systemImage: "xmark")
                        }
                    }
                }
                #if os(macOS)
                .frame(minWidth: 380, minHeight: 320)
                #endif
                .navigationTitle(navTitle)
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
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
