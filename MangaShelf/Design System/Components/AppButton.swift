//
//  AppButton.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 31/08/26.
//

import SwiftUI

struct AppButton: View {
    let title: String
    var variant: ButtonVariant = .primary
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 40)
                    .foregroundStyle(variant.background)
                Text(title)
                    .foregroundStyle(variant.foreground)
                    .fontWeight(.semibold)
            }
        }
    }
    
    enum ButtonVariant {
        case primary
        case secondary
        case primaryAlt
        case secondaryAlt
        
        var background: Color {
            switch self {
            case .primary: .accent
            case .secondary: .second
            case .primaryAlt, .secondaryAlt: .white
            }
        }
        
        var foreground: Color {
            switch self {
            case .primary, .secondary:.white
            case .primaryAlt: .accent
            case .secondaryAlt: .second
            }
        }
    }
}

#Preview {
    VStack {
        AppButton(title: "Add to Collection") {
            
        }
    }
    .padding()
    
}
