//
//  ChipView.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 29/08/26.
//

import SwiftUI

struct ChipView: View {
    let title: String
    var small: Bool = false
    var color: Color = .second
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: small ? 13.5 : 14.5, weight: .semibold))
                    .foregroundStyle(color)
            }
            .padding(.horizontal, small ? 12 : 14)
            .frame(height: small ? 32 : 36)
            .clipShape(Capsule())
            .background(color.opacity(0.15), in: .capsule)
            .overlay {
                Capsule().stroke(color, lineWidth: 1.5)
            }
            
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
    ForEach(Manga.monster.themes) { theme in
            ChipView(title: theme.theme, small: false,  action: { })
        }
    }   
}
