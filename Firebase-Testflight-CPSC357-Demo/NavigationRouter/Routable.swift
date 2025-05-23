//
//  Routable.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI

public enum NavigationType {
    case push
    case sheet
    case fullScreenCover
}

public protocol Routable: Hashable, Identifiable {
    associatedtype ViewType: View
    var navigationType: NavigationType { get }
    func viewToDisplay(router: Router<Self>) -> ViewType
}

extension Routable {
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
