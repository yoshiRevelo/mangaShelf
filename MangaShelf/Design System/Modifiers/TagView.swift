//
//  TagView.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 30/08/26.
//


import SwiftUI

struct TagView: View {
    
    let title: String
    var color: Color = .accent
    var isSelected = false
    
    var body: some View {
        Text(title)
            .bold()
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background( isSelected ?
                         color
                         : color.opacity(0.15), in: .capsule
            )
            .foregroundStyle(isSelected ? .white : color)
    }
}

#Preview {
    TagView(title: "Swift", )
    TagView(title: "Swift UI", isSelected: true)
}
