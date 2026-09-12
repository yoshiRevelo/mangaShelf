//
//  RowCollectionItemView.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 03/09/26.
//

import SwiftUI

struct RowCollectionItemView: View {
    let collectionItem: CollectionItem
    
    let onToggleComplete: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(collectionItem.cachedTitle)
                    .font(.title3)
                    .fontWeight(.medium)
                    .lineLimit(3)
                    
                Spacer()
                
                Text(collectionItem.isComplete ? "Complete" : "In progress")
                    .font(.subheadline)
                    .foregroundStyle(collectionItem.isComplete ? .success : .warning)
                    .animation(.smooth, value: collectionItem.isComplete)
                
                Button(action: onToggleComplete) {
                    Image(systemName: collectionItem.isComplete ? "checkmark.seal.fill" : "seal")
                        .font(.title2)
                        .foregroundStyle(collectionItem.isComplete ? .success : .warning)
                        .contentTransition(.symbolEffect(.replace))
                }
                .buttonStyle(.plain)
            }
            
            CollectionInditatorView(collectionItem: collectionItem)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct CollectionInditatorView: View {
    let collectionItem: CollectionItem
    
    private var readingVolume: Int {
        collectionItem.readingVolume ?? 0
    }
    
    private var readingProgress: Double { ((Double(readingVolume) * 100.0) / Double(collectionItem.ownedVolumes)) / 100.0
    }
    
    private var readingStatusColor: Color {
        readingVolume == collectionItem.ownedVolumes ? .success : .warning
    }
    
    var body: some View {
        if collectionItem.ownedVolumes > 0 {
            ProgressView(value: readingProgress)
                .tint(readingStatusColor)
        }
        
        Text("Tomo \(readingVolume.formatted())  de \(collectionItem.ownedVolumes.formatted())")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    VStack {
        RowCollectionItemView(collectionItem: CollectionItem.preview.first!) { }
        
        CollectionInditatorView(collectionItem: CollectionItem.preview.last!)
    }
}
