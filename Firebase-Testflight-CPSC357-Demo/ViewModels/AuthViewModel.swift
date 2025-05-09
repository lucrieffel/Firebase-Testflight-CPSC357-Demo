//
//  AuthViewModel.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/8/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var authError: AuthError?
    @Published var showAlert = false
    
    @State private var isLoading = false //state variable for loading animation
    
    private let db = Firestore.firestore()
    
    init() {
        userSession = Auth.auth().currentUser
        if userSession != nil {
            Task {
                await fetchCurrentUser()
            }
        }
    }
    
    func fetchCurrentUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("DEBUG: No authenticated user found.")
            return
        }
        do {
            let snapshot = try await db.collection("Users").document(uid).getDocument()
            if let data = snapshot.data() {
                do {
                    self.currentUser = try User(from: data)
                } catch {
                    print("DEBUG: Failed to parse user data: \(error.localizedDescription)")
                }
            }
            
            print("DEBUG: User data fetched successfully for UID: \(uid).")
        } catch {
            print("DEBUG: Failed to fetch user: \(error.localizedDescription)")
        }
    }
    
    func handleAuthError(_ error: Error) {
        let nsError = error as NSError
        
        // Debug full error details
        print("DEBUG: Full error details:")
        print("  - Domain: \(nsError.domain)")
        print("  - Code: \(nsError.code)")
        print("  - Description: \(nsError.localizedDescription)")
        print("  - User Info: \(nsError.userInfo)")
        
        // Correctly map Firebase auth errors
        if nsError.domain == AuthErrorDomain {
            if let errorCode = AuthErrorCode(rawValue: nsError.code) {
                let mappedError = AuthError(authErrorCode: errorCode)
                self.authError = mappedError
                
                print("DEBUG: Mapped Firebase error code \(errorCode.rawValue) to AuthError.\(String(describing: mappedError))")
            } else {
                print("DEBUG: Unrecognized Firebase auth error code: \(nsError.code)")
                self.authError = .unknown
            }
        } else {
            // For non-Firebase auth errors
            if nsError.domain == NSURLErrorDomain {
                print("DEBUG: Network error detected")
                self.authError = .networkError
            } else {
                print("DEBUG: Non-Firebase auth error domain: \(nsError.domain)")
                self.authError = .unknown
            }
        }
        
        print("DEBUG: Final auth error: \(String(describing: self.authError))")
    }
    
    // MARK: - Fetch User by ID
    func fetchUser(withID userID: String) async {
        do {
            let snapshot = try await db.collection("Users").document(userID).getDocument()
            if let data = snapshot.data() {
                do {
                    self.currentUser = try User(from: data)
                } catch {
                    print("DEBUG: Failed to parse user data: \(error.localizedDescription)")
                }
            }
            print("DEBUG: User data fetched successfully for user ID: \(userID).")
        } catch {
            print("DEBUG: Failed to fetch user by ID: \(error.localizedDescription)")
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        isLoading = true
        print("DEBUG: Signing in with email: \(email)")
        
        // Check network connectivity first
        if !NetworkMonitor.shared.isConnected {
            isLoading = false
            self.authError = .networkError
            self.showAlert = true
            
            // Also show in the global network banner
            AppEnvironment.shared.errorMessage = "Cannot sign in while offline. Please check your connection and try again."
            AppEnvironment.shared.showNetworkError = true
            
            throw NSError(domain: "AuthError", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection available."])
        }
        
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user

            // Fetch user details
            await fetchUser(withID: result.user.uid)

            print("DEBUG: Sign-in successful, user ID: \(result.user.uid)")
        } catch {
            print("DEBUG: Failed to sign in: \(error.localizedDescription)")
            handleAuthError(error)
            isLoading = false // Reset loading state when an error occurs
            self.showAlert = true // Show the alert
            throw error
        }
        isLoading = false
    }
    
    func registerUser(withName fullname: String, withEmail email: String, withPassword password: String) async throws{
        isLoading = true
        print("DEBUG: Signing in with email: \(email)")
        
        // Check network connectivity first
        if !NetworkMonitor.shared.isConnected {
            isLoading = false
            self.authError = .networkError
            self.showAlert = true
            
            // Also show in the global network banner
            AppEnvironment.shared.errorMessage = "Cannot create account while offline. Please check your connection and try again."
            AppEnvironment.shared.showNetworkError = true
            
            throw NSError(domain: "AuthError", code: -1009, userInfo: [NSLocalizedDescriptionKey: "No internet connection available."])
        }
        
        do{
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            // Create user document in Firestore
            let userData: [String: Any] = [
                "userID": result.user.uid,
                "fullname": fullname,
                "email": email,
                "userType": UserType.customer.rawValue,
                "dateCreated": Date(),
                "points": 0
            ]
            
            try await db.collection("Users").document(result.user.uid).setData(userData)
            
            await fetchUser(withID: result.user.uid)
            print("Registration successful with \(result.user.uid)")
            print("User email: \(result.user.email ?? "NO EMAIL")")
        } catch{
            print("DEBUG: Failed to register: \(error.localizedDescription)")
            isLoading = false
            handleAuthError(error)
            self.showAlert = true
            throw error
        }
        isLoading = false
    }
    
    // MARK: - Reset Password
    func resetPassword(emailAddress: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: emailAddress)
            print("DEBUG: Password reset email sent to \(emailAddress).")
        } catch {
            print("DEBUG: Failed to send reset email: \(error.localizedDescription)")
            throw error
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            print("DEBUG: User signed out successfully.")
        } catch {
            print("DEBUG: Failed to sign out: \(error.localizedDescription)")
        }
    }
}

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}
