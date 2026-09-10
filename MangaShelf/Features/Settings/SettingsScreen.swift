//
//  SettingsScreen.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 09/09/26.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(AppEnvironment.self) private var environment
    @State private var signout = false
    
    let user: UserInfo
    
    var body: some View {
        Form {
            Section("User info") {
                HStack {
                    Text("Email")
                    Spacer()
                    Text(user.email)
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text("Role")
                    Spacer()
                    Text(user.role)
                        .foregroundStyle(.secondary)
                }
                
                Toggle("Is active", isOn: .constant(user.isActive))
                    .disabled(true)
            }
            
            Section("Information") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(Bundle.appVersion())
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(AppTab.settings.title)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    signout = true
                } label: {
                    Label("Sign out", systemImage: "door.left.hand.open")
                }
                .tint(.second)
            }
        }
        
        .alert("Sign out?", isPresented: $signout) {
            Button("Sign out", role: .destructive) {
                Task {
                    await environment.sessionStore.signOut()
                }
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Your session will be closed")
        }
    
    }
}
#Preview {
    NavigationStack {
        SettingsScreen(user: UserInfo(id: UUID(), isActive: true, isAdmin: false, role: "user", email: "test@test.com"))
    }
    .environment(AppEnvironment.preview())
}
