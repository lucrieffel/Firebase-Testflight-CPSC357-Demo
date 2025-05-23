//
//  ResetPasswordView.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var email: String
    @EnvironmentObject private var router: Router<UnAuthorizedRouter>
    @State private var showConfirmation = false

    var backButtonText: String
    var showBackButton: Bool
    var resetContext: String?

    init(email: String? = nil, backButtonText: String = "Back", showBackButton: Bool = true, resetContext: String? = nil) {
        _email = State(initialValue: email ?? "")
        self.backButtonText = backButtonText
        self.showBackButton = showBackButton
        self.resetContext = resetContext
    }

    var body: some View {
        VStack {
            Image("logo-placeholder")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 140)
                .padding(.vertical, 32)

            if let context = resetContext {
                Text("Reset \(context) Password")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Email Address")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                ZStack(alignment: .trailing) {
                    TextField("Enter your email address", text: $email)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 0.5))
                        .frame(width: UIScreen.main.bounds.width - 32)
                }
            }
            .padding()

            Button {
                Task{
                    try await AppEnvironment.shared.authViewModel.resetPassword(emailAddress:email )
                    showConfirmation = true
                }
            } label: {
                HStack {
                    Text("SEND RESET LINK")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 50)
            }
            .background(Color(.systemBlue))
            .cornerRadius(10)
            .padding()

            Spacer()

            if showBackButton {
                Button {
                    router.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text(backButtonText)
                            .fontWeight(.semibold)
                    }
                }
            }
        }
        .alert("Password Reset Instructions Sent", isPresented: $showConfirmation) {
            Button("OK", role: .cancel) { router.dismiss() }
        } message: {
            Text("Instructions to reset your password have been sent to your email.")
        }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(email: "example@audiobuddy.com", backButtonText: "Back to Login", showBackButton: true, resetContext: "Parent")
    }
}


#Preview {
    ResetPasswordView()
}

