//
//  CollectionItemScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 02/09/26.
//

import SwiftUI

struct CollectionItemScreen: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(\.dismiss) private var dismiss
    
    @State private var draft: DraftItem
    @State private var viewModel: CollectionItemViewModel?
    let collectionItem: CollectionItem
    let onSave: () -> Void
    let onChange: () -> Void
    
    @State private var showDeleteAlert = false
    
    private var readingVolume: Binding<Int> {
        Binding(
            get: { draft.readingVolume ?? 0},
            set: { draft.readingVolume = $0 }
        )
    }
    
    private var totalVolumes: Int {
        collectionItem.totalVolumes ?? 1
    }
    
    private var isDirty: Bool {
        (draft.ownedVolumes != collectionItem.ownedVolumes) ||
        (draft.isComplete != collectionItem.isComplete) ||
        (draft.readingVolume != collectionItem.readingVolume)
    }
    
    init(collectionItem: CollectionItem, onSave: @escaping () -> Void, onChange: @escaping () -> Void){
        self.collectionItem = collectionItem
        self.onSave = onSave
        self.onChange = onChange
        _draft = State(initialValue: DraftItem(ownedVolumes: collectionItem.ownedVolumes, readingVolume: collectionItem.readingVolume, isComplete: collectionItem.isComplete) )
    }
    
    var body: some View {
        Group {
            if let viewModel {
                content(viewModel)
            } else {
                ContentUnavailableView("There is no information to show", systemImage: "apple.books.pages")
            }
        }
        .onAppear {
            if viewModel == nil {
                viewModel = CollectionItemViewModel(collectionItem: collectionItem, repository: environment.collectionRepository)
            }
        }
        .navigationTitle(collectionItem.cachedTitle)
        .navigationBarTitleDisplayMode(.inline)
        .presentationDetents([.medium, .large])
        .interactiveDismissDisabled(isDirty)
        .presentationDragIndicator(isDirty ? .hidden : .visible)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
                    Task {
                        await viewModel?.upsert(draft: draft)
                        onSave()
                        dismiss()
                    }
                    
                } label: {
                    Label("", systemImage: "checkmark")
                }
                .tint(.second)
                .clipShape(.circle)
                .disabled(!isDirty)
            }
            
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    showDeleteAlert = true
                } label: {
                    Label("", systemImage: "trash")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .alert("Delete item?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel?.deleteItem(draft: draft)
                    onChange()
                    dismiss()
                }
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("\(collectionItem.cachedTitle) will be removed from your collection")
        }
        
        
    }
    
    @ViewBuilder
    private func content(_ viewModel: CollectionItemViewModel) -> some View {
        @Bindable var viewModel = viewModel
        
        Form {
            Section {
                Stepper("Owned volumes \(draft.ownedVolumes)", value: $draft.ownedVolumes
                        , in: 0...totalVolumes)
                
                Stepper("Reading volume \(readingVolume.wrappedValue)", value: readingVolume, in: 0...draft.ownedVolumes)
            } header: {
                Text("Volumes Information")
            } footer: {
                Text("Total volumes: \(totalVolumes.formatted())")
            }
            
            Section() { } header: {
                Toggle("Collection complete", isOn: $draft.isComplete)
            }
        }
    }
}


#Preview {
    NavigationStack {
        CollectionItemScreen(collectionItem: CollectionItem.preview.first!) { } onChange: {}
    }
    .environment(AppEnvironment.preview())
}

struct DraftItem: Equatable {
    var ownedVolumes: Int = 0
    var readingVolume: Int? = 0
    var isComplete = false
}
