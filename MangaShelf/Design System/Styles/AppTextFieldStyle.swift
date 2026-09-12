//
//  AppTextFieldStyle.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 08/09/26.
//
import SwiftUI

struct AppTextFieldStyle: TextFieldStyle {

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 17))
            .foregroundStyle(Color.ink)
            .tint(.accent)
            #if os(macOS)
            .textFieldStyle(.plain)
            #endif
    }
}
