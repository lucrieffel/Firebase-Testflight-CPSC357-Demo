//
//  ResetPasswordForm.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI

struct ResetPasswordForm: View {
    @State private var email: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoading: Bool = false

    @EnvironmentObject private var authModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ZStack {
                ColorType.darkBlue.color.opacity(0.05)
                    .ignoresSafeArea()
                
                Form {
                    Section {
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                    } header: {
                        VStack(spacing: 8) {
                            Image(systemName: "key.fill")
                                .font(.system(size: 30))
                                .foregroundColor(ColorType.blue1.color)
                            
                            Text("Enter your email to receive password reset instructions")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 8)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 16)
                    }
                    
                    Section {
                        Button(action: {
                            Task {
                                await sendResetInstructions()
                            }
                        }) {
                            HStack {
                                Spacer()
                                if isLoading {
                                    ProgressView()
                                        .tint(ColorType.blue1.color)
                                } else {
                                    Text("Send Reset Instructions")
                                        .fontWeight(.semibold)
                                        .foregroundColor(ColorType.blue1.color)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(ColorType.blue1.color, lineWidth: 2)
                            )
                        }
                        .disabled(email.isEmpty || isLoading)
                        .listRowBackground(Color.clear)
                    }
                }
            }
            .onAppear {
                if let userEmail = AppEnvironment.shared.authViewModel.currentUser?.email {
                    email = userEmail
                }
            }
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Password Reset"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage == "Reset instructions sent successfully." {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func sendResetInstructions() async {
        guard email.contains("@") else {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return
        }
        isLoading = true
        do {
            try await AppEnvironment.shared.authViewModel.resetPassword(emailAddress: email)
            alertMessage = "Reset instructions sent successfully."
        } catch {
            alertMessage = error.localizedDescription
        }
        isLoading = false
        showAlert = true
    }
}

//
//#Preview {
//    ResetPasswordForm()
//}
