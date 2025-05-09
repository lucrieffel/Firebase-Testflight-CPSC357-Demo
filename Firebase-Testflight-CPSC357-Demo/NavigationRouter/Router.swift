//
//  Router.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import Foundation
import SwiftUI

public class Router<Destination: Routable>: ObservableObject {
    /// Used to programatically control a navigation stack
    @Published public var path: NavigationPath = NavigationPath()
    /// Used to present a view using a sheet
    @Published public var presentingSheet: Destination?
    /// Used to present a view using a full screen cover
    @Published public var presentingFullScreenCover: Destination?
    /// Used by presented Router instances to dismiss themselves
    @Published public var isPresented: Binding<Destination?>
    public var isPresenting: Bool {
        presentingSheet != nil || presentingFullScreenCover != nil
    }
    
    public init(isPresented: Binding<Destination?>) {
        self.isPresented = isPresented
    }
    
    /// Returns the view associated with the specified `Routable`
    public func view(for route: Destination) -> some View {
        route.viewToDisplay(router: router(routeType: route.navigationType))
            //.toolbar(.hidden, for: .navigationBar) // Hide Navigation Bar
    }
    
    /// Routes to the specified `Routable`.
    public func routeTo(_ route: Destination) {
        // First dismiss any active presented views
        dismissActiveViews()
        
        switch route.navigationType {
        case .push:
            push(route)
        case .sheet:
            presentSheet(route)
        case .fullScreenCover:
            presentFullScreen(route)
        }
    }
    
    // Dismiss any active presented views before navigation
    private func dismissActiveViews() {
        // Dismiss our own router's sheets
        if presentingSheet != nil {
            presentingSheet = nil
        }
        
        if presentingFullScreenCover != nil {
            presentingFullScreenCover = nil
        }
        
        // Broadcast to all views that they should dismiss their sheets
//        NotificationCenter.default.post(name: .dismissAllSheets, object: nil)
        
        // Direct access to common view models that might be presenting sheets
        // Access shared environment models that might have presentation state
        DispatchQueue.main.async {
            // Try to access all possible view models that might be presenting sheets
            // This ensures even deeply nested presentations will be dismissed
            
            // Add additional view model dismissals here if needed:
            // e.g., AppEnvironment.shared.someViewModel.dismissPresentations()
        }
    }
    
    // Pop to the root screen in our hierarchy
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    // Dismisses presented screen or self
    public func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        } else if presentingSheet != nil {
            presentingSheet = nil
        } else if presentingFullScreenCover != nil {
            presentingFullScreenCover = nil
        } else {
            isPresented.wrappedValue = nil
        }
    }
    
    private func push(_ appRoute: Destination) {
        path.append(appRoute)
    }
    
    private func presentSheet(_ route: Destination) {
        self.presentingSheet = route
    }
    
    private func presentFullScreen(_ route: Destination) {
        self.presentingFullScreenCover = route
    }
    
    // Return the appropriate Router instance based
    // on `NavigationType`
    private func router(routeType: NavigationType) -> Router {
        switch routeType {
        case .push:
            return self
        case .sheet:
            return Router(
                isPresented: Binding(
                    get: { self.presentingSheet },
                    set: { self.presentingSheet = $0 }
                )
            )
        case .fullScreenCover:
            return Router(
                isPresented: Binding(
                    get: { self.presentingFullScreenCover },
                    set: { self.presentingFullScreenCover = $0 }
                )
            )
        }
    }
}
