//
//  RootView.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI

struct RootView: View {
    // Reads the app's current state from persistent storage (UserDefaults via AppStorage).
    @AppStorage("appState") var appStateEnum: AppStateEnum?
    
    // Holds the current state locally within the view.
    @State private var currentAppState: AppStateEnum = .unknown
    
    @ObservedObject private var appEnv = AppEnvironment.shared
    
    var body: some View {
        Group {
            // Conditionally render views based on the current app state.
            switch currentAppState {
            case .authorized:
                // User is authenticated – show main content using routing.
                RoutingView(authorizedRouter.self) { router in
                    ContentView()
                }
            case .unauthorized:
                // User is not authenticated – show the login screen.
                RoutingView(UnAuthorizedRouter.self) { router in
                    LoginView()
                }
            case .unknown:
                // Still determining the app state – show a loading screen with animation 
                LoadingScreen()
            }
        }
        .onAppear {
            // Set initial state from persistent storage if available
            if let savedState = appStateEnum {
                currentAppState = savedState
            }
        }
        .onChange(of: appStateEnum) { _, newValue in
            // Update currentAppState when appStateEnum changes
            if let newState = newValue {
                currentAppState = newState
            }
        }
    }
}
