//
//  AuthNavigationStack.swift
//  Cachecroute
//
//  Created by Gambitto on 12/11/2026.
//
import Foundation
import SwiftUI

struct AuthNavigationStack: View {
    let authService: AuthService
    @State private var showSignup = false
    var body: some View {
        NavigationStack {
            LoginView(authService: authService, onNavigateToSignup: { showSignup = true })
                .navigationDestination(isPresented: $showSignup) {
                    SignupView(authService: authService)
                }
        }
    }
}
