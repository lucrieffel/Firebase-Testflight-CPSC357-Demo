//
//  AppEnvironment.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/8/25.
//

import Foundation
import SwiftUI
import Firebase

@MainActor
class AppEnvironment : ObservableObject{
    static let shared = AppEnvironment() //shared instance of AppEnvironment to manage all of your ViewModels
    
    var authorizedRouter: Router<authorizedRouter>?
    
    //List each view model here as a published variable
    @Published var authViewModel = AuthViewModel()
//    @Published var moodViewModel = MoodViewModel()
//    @Published var copingActivityViewModel = CopingActivityViewModel()
    
}

// A separate singleton class to manage user-related data.
class UserData {
    static let shared = UserData()
    
    // Stores the app's state using AppStorage, so it's persisted across launches.
    // AppStateEnum is used to determine which screen to show (e.g., login, home, etc.).
    @AppStorage("appState") var appStateEnum: AppStateEnum?
    
}


// Enum representing different possible states of the app.
enum AppStateEnum: IntegerLiteralType {
    case authorized // User is logged in and authorized.
    case unauthorized  // User is not logged in.
    case unknown // App state is not determined yet. This triggers a loading screen
}
