//
//  SynopsisScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 30/08/26.
//

import SwiftUI

struct SynopsisScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    let title: String
    let synopsis: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.largeTitle.bold())
                .padding()
            
            ScrollView {
                Text(synopsis)
                    .font(.body)
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        }.overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Label("Close", systemImage: "xmark")
                    .frame(width: 30, height: 30)
                    .labelStyle(.iconOnly)
            }
            .fontWeight(.semibold)
            .buttonStyle(.borderedProminent)
            .tint(.second)
            .clipShape(.circle)
        }
        
        .frame(maxHeight: .infinity)
        .padding()
        .presentationDetents([.medium])
        .interactiveDismissDisabled(true)
    }
}

#Preview {
    SynopsisScreen(title: Manga.monster.title, synopsis: Manga.monster.synopsis ?? "")
}
