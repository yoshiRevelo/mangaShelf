//
//  AuthScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 08/09/26.
//

import SwiftUI

struct AuthScreen: View {
    @Environment(AppEnvironment.self) private var environment
    @Environment(AppRouter.self) private var router
    @State private var viewModel = AuthViewModel()
    
    var title: String {
        viewModel.mode == .login ? "Sign in" : "Sign up"
    }
    
    var description: String {
        "\(title) to save your personal collection"
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        @Bindable var router = router
        
        ScrollView {
            VStack(alignment: .leading) {
                form(viewModel)
            }
            #if os(iOS)
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
            #endif
        }
        .onAppear {
            viewModel.reset()
        }
    }
    
    @ViewBuilder
    private func form(_ viewModel: AuthViewModel) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 30, weight: .bold))
            
            Text(description)
                .font(.system(size: 16))
                .padding(.top, 8)
                .padding(.bottom, 26)
            
            VStack(spacing: 16) {
                #if os(iOS)
                AppField(label: "Email", text: $viewModel.email, placeholder: "hello@apple.com", systemImage: "envelope", error: nil, keyboardType: .emailAddress, textContentType: .emailAddress, autocapitalization: .never)
                #else
                AppField(label: "Email", text: $viewModel.email, placeholder: "hello@apple.com", systemImage: "envelope")
                #endif
                
                #if os(iOS)
                AppField(label: "Password", text: $viewModel.password, placeholder: "Your password", systemImage: "lock", isSecure: true, textContentType: .password)
                #else
                AppField(label: "Password", text: $viewModel.password, placeholder: "Your password", systemImage: "lock", isSecure: true)
                #endif
                
                if viewModel.mode == .register {
                    AppField(label: "Confirm Password", text: $viewModel.confirmPassword, placeholder: "Confirm  password", systemImage: "lock", isSecure: true)
                        .animation(.snappy, value: viewModel.mode)
                }
                
                Button(String(localized: viewModel.mode == .login ? "Don't have an account? Sign up" : "Already have an account? Sign in")) {
                    viewModel.toggleMode()
                }
                .font(.system(size: 14.5, weight: .semibold))
                .foregroundStyle(Color.second)
                .frame(maxWidth: .infinity, alignment: .trailing)
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
                
                AppButton(title: title, variant: .primary, isLoading: viewModel.isLoading) {
                    Task {
                        await submit() }
                }
                .disabled(viewModel.isLoading)
                #if os(macOS)
                .buttonStyle(.plain)
                #endif
            }
        }
        .padding()
    }
    
    private func submit() async {
        let success = await viewModel.submit(using: environment.sessionStore)
        if success {
            if viewModel.mode == .register {
                viewModel.toggleMode()
                router.toast = ToastMessage("Account created, sign in", kind: .success)
            }
        } else {
            router.toast = ToastMessage(viewModel.errorMessage, kind: .error)
        }
    }
    
}

#Preview {
    AuthScreen()
        .environment(AppEnvironment.preview())
        .environment(AppRouter())
}
