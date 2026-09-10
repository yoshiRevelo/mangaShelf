//
//  AppTextFieldStyle.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 08/09/26.
//
import SwiftUI

struct AppTextFieldStyle: TextFieldStyle {
    // swiftlint:disable:next identifier_name
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.system(size: 17))
            .foregroundStyle(Color.ink)
            .tint(.accent)
    }
}
