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
    
    //Router
    var authorizedRouter: Router<authorizedRouter>?
    
    //Network related error message banners
    @Published var showNetworkError: Bool = false           // Track's network connection
    @Published var errorMessage: String = ""  // Track's network connection
    
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
    
    // Property to store pending notification route with persistence
    private let pendingActionKey = "pendingNotificationAction"
    
    var pendingNotificationAction: authorizedRouter? {
        get {
            // Read from UserDefaults
            if let routeRawValue = UserDefaults.standard.string(forKey: pendingActionKey),
               let route = getRouterFromString(routeRawValue) {
                return route
            }
            return nil
        }
        set {
            // Save to UserDefaults
            if let newValue = newValue {
                let routeString = getStringFromRouter(newValue)
                UserDefaults.standard.set(routeString, forKey: pendingActionKey)
            } else {
                UserDefaults.standard.removeObject(forKey: pendingActionKey)
            }
        }
    }
    
    private func getStringFromRouter(_ router: authorizedRouter) -> String {
        switch router {
        case .home: return "home"
        case .community: return "community"
        }
    }
    
    // Helper to convert string to router case
    private func getRouterFromString(_ string: String) -> authorizedRouter? {
        let components = string.split(separator: ":")
        let routeType = String(components[0])
        switch routeType {
        case "home": return .home
        case "community": return .community
        default: return nil
        }
    }
}


// Enum representing different possible states of the app.
enum AppStateEnum: IntegerLiteralType {
    case authorized // User is logged in and authorized.
    case unauthorized  // User is not logged in.
    case unknown // App state is not determined yet. This triggers a loading screen
}
