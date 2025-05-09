//
//  LoadingScreen.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct LoadingScreen: View {
    @State private var isLoading = true
    @State private var scale: CGFloat = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        Group {
            if isLoading {
                ZStack {
                    // Background Gradient
                    LinearGradient(gradient: Gradient(colors:
                                                        [.white,
                                                         ColorType.blue2.color, ColorType.blue1.color]),
                                   startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea(.all)
                    
                    LogoImage()
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .onAppear {
                            UserData.shared.appStateEnum = nil
                            withAnimation(.easeIn(duration: 1.2)){
                                self.scale = 1.0
                                self.opacity = 1.0
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                checkUserSession()
                            }
                        }
                }
            } else {
                
            }
        }
    }
    
    private func checkUserSession() {
        // Single place to check auth state
        if Auth.auth().currentUser != nil {
            // Only fetch if needed
            if AppEnvironment.shared.authViewModel.currentUser == nil {
                Task {
                    print("Loading user data...")
                    await AppEnvironment.shared.authViewModel.fetchCurrentUser()
                    DispatchQueue.main.async {
                        self.isLoading = false
                        setNecessaryAppState()
                    }
                }
            } else {
                // Already have the user data
                self.isLoading = false
                print("already have user data")
                setNecessaryAppState()
            }
        } else {
            // No user logged in
            self.isLoading = false
            setNecessaryAppState()
            print("not logged in")
        }
    }
    
    func setNecessaryAppState() {
        if AppEnvironment.shared.authViewModel.userSession != nil && AppEnvironment.shared.authViewModel.currentUser != nil {
            UserData.shared.appStateEnum = .authorized
        } else {
            UserData.shared.appStateEnum = .unauthorized
        }
    }
}

#Preview {
    LoadingScreen()
}
