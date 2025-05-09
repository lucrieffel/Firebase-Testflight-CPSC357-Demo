//
//  AuthorizedRouter.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import Foundation
import SwiftUI

enum authorizedRouter: Routable, Equatable {
    case home
//    case profile
    
    @ViewBuilder
    func viewToDisplay(router: Router<Self>) -> some View {
        
        switch self {
        case .home:
            ContentView()
//        case .profile:
//            ProfileView()
        }
    }

    //If you want to navigate to views via push notifications
    var navigationType: NavigationType {
        return .push
    }
}
