//
//  Toast.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 08/09/26.
//

import SwiftUI

struct ToastMessage: Equatable, Identifiable {
    enum Kind {
        case success
        case error
    }
    
    let id = UUID()
    let text: String
    let kind: Kind
    
    init(_ text: String, kind: Kind = .success) {
        self.text = text
        self.kind = kind
    }
    
    var systemImage: String {
        switch kind {
        case .success: "checkmark"
        case .error: "exclamationmark.triangle.fill"
        }
    }
    
    var tint: Color {
        switch kind {
        case .success: .success
        case .error: .warning
        }
    }
}

struct ToastView: View {
    let toast: ToastMessage
    
    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: toast.systemImage)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(toast.tint)
            Text(toast.text)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: .capsule)
        .background(Color.ink.opacity(0.92), in: .capsule)
        .shadow(color: .black.opacity(0.25), radius: 12, y: 8)
        
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: ToastMessage?
    let bottomPadding: CGFloat
    func body(content: Content) -> some View {
        content.overlay(alignment: .bottom) {
            if let toast {
                ToastView(toast: toast)
                    .padding(.bottom, bottomPadding)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .task(id: toast.id) {
                        try? await Task.sleep(for: .seconds(1.9))
                        withAnimation(.snappy) { self.toast = nil }
                    }
            }
        }
        .animation(.snappy, value: toast)
    }
}

nonisolated extension View {
    func toast(_ toast: Binding<ToastMessage?>, bottomPadding: CGFloat = 24) -> some View {
        modifier(ToastModifier(toast: toast, bottomPadding: bottomPadding))
    }
}

#Preview {
    VStack {
        ToastView(toast: ToastMessage("This is a test", kind: .success))
        ToastView(toast: ToastMessage("This is an error test", kind: .error))
    }
}
