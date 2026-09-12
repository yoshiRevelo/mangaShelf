//
//  AppField.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 08/09/26.
//
import SwiftUI

struct AppField: View {
    let label: LocalizedStringKey?
    @Binding var text: String
    var placeholder: LocalizedStringKey = ""
    var systemImage: String?
    var isSecure: Bool = false
    var multiline: Bool = false
    var error: String?
    
    #if os(iOS)
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType?
    var autocapitalization: TextInputAutocapitalization = .sentences
    #endif

    @State private var revealSecure = false
    @FocusState private var isFocused: Bool

    private var borderColor: Color {
        if error != nil { return .warning }
        return isFocused ? .accent : .second
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            if let label {
                Text(label)
                    .font(.system(size: 13, weight: .semibold))
                    .padding(.leading, 4)
            }

            HStack(alignment: multiline ? .top : .center, spacing: 10) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 18))
                        .foregroundStyle(Color.ink.opacity(0.2))
                        .frame(width: 22)
                }

                fieldView

                if isSecure {
                    Button {
                        revealSecure.toggle()
                    } label: {
                        Image(systemName: revealSecure ? "eye.slash" : "eye")
                            .font(.system(size: 18))
                            .foregroundStyle(.second)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, multiline ? 14 : 0)
            .frame(minHeight: multiline ? 96 : 52, alignment: multiline ? .top : .center)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.field))
            .overlay {
                RoundedRectangle(cornerRadius: AppRadius.field)
                    .stroke(borderColor, lineWidth: 1.5)
            }
            .animation(.easeInOut(duration: 0.15), value: borderColor)

            if let error {
                Text(error)
                    .font(.system(size: 12.5))
                    .foregroundStyle(Color.warning)
                    .padding(.leading, 4)
            }
        }
    }

    @ViewBuilder
    private var fieldView: some View {
        Group {
            if multiline {
                TextField("", text: $text, axis: .vertical)
                    .lineLimit(3...6)
            } else if isSecure && !revealSecure {
                SecureField("", text: $text)
            } else {
                TextField("", text: $text)
            }
        }
        .textFieldStyle(AppTextFieldStyle())
        #if os(iOS)
        .keyboardType(keyboardType)
        .textContentType(textContentType)
        .textInputAutocapitalization(autocapitalization)
        .autocorrectionDisabled(isSecure || keyboardType == .emailAddress)
        #else
        .autocorrectionDisabled(isSecure)
        #endif
        .focused($isFocused)
        .overlay(alignment: multiline ? .topLeading : .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.ink.opacity(0.2))
                    .tint(Color.ink.opacity(0.2))
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    @Previewable @State var email = ""
    @Previewable @State var password = "secret"
    VStack(spacing: 16) {
    #if os(iOS)
        AppField(label: "Email", text: $email, placeholder: "hola@ejemplo.com", systemImage: "envelope", keyboardType: .emailAddress, textContentType: .emailAddress, autocapitalization: .never)
        
        AppField(label: "Email", text: $email, placeholder: "hola@ejemplo.com", systemImage: "envelope", textContentType: .password, autocapitalization: .never)
    #else
        AppField(label: "Email", text: $email, placeholder: "hola@ejemplo.com", systemImage: "envelope")
    #endif
    }
    .padding()
    //    .background(Color.appSurface)
}
