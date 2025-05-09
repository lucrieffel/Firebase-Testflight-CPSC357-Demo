//
//  RegistrationView.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseAuth

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullname = ""
    @State private var confirmPassword = ""
    @EnvironmentObject private var router: Router<UnAuthorizedRouter>
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Image("logo-placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 100)
                    
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email Address")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            ZStack(alignment: .trailing) {
                                CustomTextField(placeholder: "name@example.com", text: $email, autocapitalization: .never)
                                
                                if !email.isEmpty {
                                    Image(systemName: isValidEmail(email) ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(isValidEmail(email) ? .green : .red)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            ZStack(alignment: .trailing) {
                                CustomTextField(placeholder: "Enter your full name", text: $fullname, autocapitalization: .words, capitalizeWords: false)
                                
                                if !fullname.isEmpty {
                                    Image(systemName: isValidFullName(fullname) ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(isValidFullName(fullname) ? .green : .red)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Password")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            ZStack(alignment: .trailing) {
                                CustomTextField(placeholder: "Enter your password", text: $password, isSecure: true, autocapitalization: .never)
                                
                                if !password.isEmpty {
                                    Image(systemName: isValidPassword(password) ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(isValidPassword(password) ? .green : .red)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Confirm Password")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            ZStack(alignment: .trailing) {
                                CustomTextField(placeholder: "Confirm your password", text: $confirmPassword, isSecure: true, autocapitalization: .never)
                                
                                if !confirmPassword.isEmpty {
                                    Image(systemName: password == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(password == confirmPassword ? .green : .red)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    Button {
                        Task {
                            do {
                                // Check network connectivity first
                                if !NetworkMonitor.shared.isConnected {
                                    AppEnvironment.shared.errorMessage = "Cannot create account while offline. Please check your connection and try again."
                                    AppEnvironment.shared.showNetworkError = true
                                    return
                                }
                                
                                isLoading = true
                                // Trim spaces only for the email field
                                let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                                try await AppEnvironment.shared.authViewModel.registerUser(withName: fullname, withEmail: trimmedEmail, withPassword: password)
                                // Set app state to authorized after successful registration
                                UserData.shared.appStateEnum = .authorized
                                
                                // Add a slight delay for a smooth transition
                                try await Task.sleep(nanoseconds: 1_000_000_000) // 1.0 seconds delay
                                
                                isLoading = false
                                // Let the authentication flow handle the navigation
                                router.dismiss()
                            }
                            catch {
                                // Error is already handled in the AuthViewModel
                                // Just need to ensure loading state is reset here too
                                isLoading = false
                            }
                        }
                    } label: {
                        HStack {
                            Text(isLoading ? "CREATING ACCOUNT..." : "SIGN UP")
                                .fontWeight(.semibold)
                            if !isLoading {
                                Image(systemName: "arrow.right")
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 40)
                    }
                    .background(Color(.systemBlue))
                    .disabled(!formIsValid || isLoading)
                    .opacity((formIsValid && !isLoading) ? 1.0 : 0.5)
                    .cornerRadius(10)
                    .padding(.top)
                    
                    Spacer()
                    
                    Button {
                        router.dismiss()
                    } label: {
                        HStack(spacing: 2) {
                            Text("Already have an account?")
                            Text("Sign In")
                                .fontWeight(.bold)
                        }
                        .font(.system(size: 14))
                    }
                }
            }
        }
        .overlay(
            Group {
                if isLoading {
                    AddTaskLoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.5))
                }
            }
        )
        .alert(isPresented: .init(
            get: { AppEnvironment.shared.authViewModel.showAlert },
            set: { AppEnvironment.shared.authViewModel.showAlert = $0 }
        )) {
            Alert(title: Text(AppEnvironment.shared.authViewModel.authError?.title ?? "Registration Error"),
                  message: Text(AppEnvironment.shared.authViewModel.authError?.description ?? "An unknown error occurred."),
                  dismissButton: .default(Text("OK")))
        }
        .onAppear {
            // Check network connectivity when view appears
            if !NetworkMonitor.shared.isConnected {
                // Display warning about offline registration limitations
                AppEnvironment.shared.errorMessage = "Account registration requires internet connection."
                AppEnvironment.shared.showNetworkError = true
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && !fullname.isEmpty
        && password == confirmPassword
        && password.count > 5
    }
}

private func isValidEmail(_ email: String) -> Bool {
    // Basic email validation logic
    return email.contains("@") && email.contains(".")
}

private func isValidPassword(_ password: String) -> Bool {
    // Password should be at least 6 characters long
    return password.count >= 6
}

private func isValidFullName(_ name: String) -> Bool {
    // Full name should contain at least two words
    return name.split(separator: " ").count >= 2
}
