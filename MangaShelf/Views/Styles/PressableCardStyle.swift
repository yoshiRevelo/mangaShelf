//
//  PressableCardStyle.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 29/08/26.
//
import SwiftUI

struct PressableCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.985 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
