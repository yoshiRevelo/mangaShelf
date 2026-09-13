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
            
            CollectionInditatorView(readingVolume: collectionItem.readingVolume ?? 0, ownedVolumes: collectionItem.ownedVolumes)
                .frame(maxWidth: .infinity, alignment: .trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#Preview {
    VStack {
        RowCollectionItemView(collectionItem: CollectionItem.preview.first!) { }
        
        CollectionInditatorView(readingVolume: 3, ownedVolumes: 1)
    }
}
