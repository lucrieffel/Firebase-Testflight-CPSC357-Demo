//
//  LoginView.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showRegistration = false
    @State private var isLoading = false
    @EnvironmentObject private var router: Router<UnAuthorizedRouter>

    var body: some View {
            VStack {
                Image("logo-placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)

                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email Address")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        CustomTextField(placeholder: "name@example.com", text: $email, autocapitalization: .never)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        CustomTextField(placeholder: "Enter your password", text: $password, isSecure: true, autocapitalization: .never)
                        
                        HStack {
                            Spacer()
                            
                            Button {
                                router.routeTo(.forgotPassword(email: email))
                            } label: {
                                Text("Forgot Password?")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.blue)
                            }

                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)

                Button {
                    // Check network connectivity first
                    if !NetworkMonitor.shared.isConnected {
                        AppEnvironment.shared.errorMessage = "Cannot sign in while offline. Please check your connection and try again."
                        AppEnvironment.shared.showNetworkError = true
                        return
                    }
                    
                    isLoading = true
                    Task {
                        do {
                            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
                            let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
                            try await AppEnvironment.shared.authViewModel.signIn(withEmail: trimmedEmail, password: trimmedPassword)

                            // Add a slight delay for a smooth transition
                            try await Task.sleep(nanoseconds: 1_000_000_000) // 1.0 seconds delay
                            
                            if AppEnvironment.shared.authViewModel.userSession != nil && AppEnvironment.shared.authViewModel.currentUser != nil {
                                UserData.shared.appStateEnum = .authorized
                            }
                            isLoading = false
                            router.dismiss()
                        } catch {
                            // Error is already handled in the AuthViewModel
                            // Just need to ensure loading state is reset here too
                            print("error: \(error)")
                            isLoading = false
                        }
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 40)
                }
                .background(Color(.systemBlue))
                .cornerRadius(10)
                .padding(.top, 24)

                Spacer()

                Button {
                    router.routeTo(.registration)
                } label: {
                    HStack {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size: 14))
                }
                
            }
            .alert(isPresented: .init(
                get: { AppEnvironment.shared.authViewModel.showAlert },
                set: { AppEnvironment.shared.authViewModel.showAlert = $0 }
            )) {
                if AppEnvironment.shared.authViewModel.authError == .userNotFound {
                    return Alert(
                        title: Text(AppEnvironment.shared.authViewModel.authError?.title ?? "Account Not Found"),
                        message: Text(AppEnvironment.shared.authViewModel.authError?.description ?? ""),
                        primaryButton: .default(Text("Create Account")) {
                            showRegistration = true
                        },
                        secondaryButton: .cancel()
                    )
                } else if AppEnvironment.shared.authViewModel.authError == .malformedCredential {
                    return Alert(
                        title: Text(AppEnvironment.shared.authViewModel.authError?.title ?? "Invalid Credential"),
                        message: Text(AppEnvironment.shared.authViewModel.authError?.description ?? "The supplied auth credential is malformed or has expired."),
                        dismissButton: .default(Text("OK"))
                    )
                } else {
                    return Alert(
                        title: Text(AppEnvironment.shared.authViewModel.authError?.title ?? "Authentication Error"),
                        message: Text(AppEnvironment.shared.authViewModel.authError?.description ?? "An unknown error occurred."),
                        dismissButton: .default(Text("OK"))
                    )
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
            .onAppear {
                // Check network connectivity when view appears
                if !NetworkMonitor.shared.isConnected {
                    // Display warning about offline authentication limitations
                    AppEnvironment.shared.errorMessage = "Login requires a stable internet connection."
                    AppEnvironment.shared.showNetworkError = true
                }
            }
    }
}

#Preview {
    LoginView()
}
