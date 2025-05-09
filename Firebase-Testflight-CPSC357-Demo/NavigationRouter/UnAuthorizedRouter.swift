//
//  UnAuthorizedRouter.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI

enum UnAuthorizedRouter: Routable {
    case splash
    case login
    case forgotPassword(email: String)
    case registration
    
    @ViewBuilder
    func viewToDisplay(router: Router<Self>) -> some View {
        
        switch self {
        case .splash:
            LoadingScreen()
        case .login:
            LoginView()
        case .forgotPassword(let email):
            ResetPasswordView(email: email, backButtonText: "Back to Login", showBackButton: true, resetContext: "")
        case .registration:
            RegistrationView()
        }
    }

    var navigationType: NavigationType {
        .push
    }
}
