//
//  CollectionInditatorView.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 12/09/26.
//

import SwiftUI

struct CollectionInditatorView: View {
    let readingVolume: Int
    let ownedVolumes: Int
    
    private var readingProgress: Double {
        guard ownedVolumes > 0 else { return 0 }
        return min(Double(readingVolume) / Double(ownedVolumes), 1.0)
    }
    
    private var readingStatusColor: Color {
        readingVolume == ownedVolumes ? .success : .warning
    }
    
    var body: some View {
        if ownedVolumes > 0 {
            ProgressView(value: readingProgress)
                .tint(readingStatusColor)
            
            Text("Volume \(readingVolume.formatted()) of \(ownedVolumes.formatted())")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VStack {
        CollectionInditatorView(readingVolume: 1, ownedVolumes: 3)
    }
}
