//
//  NavigationRouter.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI

public struct RoutingView<Content: View, Destination: Routable>: View {
    @StateObject var router: Router<Destination> = .init(isPresented: .constant(.none))
    private let rootContent: (Router<Destination>) -> Content
    
    public init(_ routeType: Destination.Type, @ViewBuilder content: @escaping (Router<Destination>) -> Content) {
        self.rootContent = content
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            rootContent(router)
                .navigationDestination(for: Destination.self) { route in
                    router.view(for: route)
                }
        }
        .environmentObject(router)
        //These are for routing your sheets/forms and views
        .sheet(item: $router.presentingSheet) { route in
            router.view(for: route)
        }
        .fullScreenCover(item: $router.presentingFullScreenCover) { route in
            router.view(for: route)
        }
        .onAppear {
            if let router = router as? Router<authorizedRouter> {
                AppEnvironment.shared.authorizedRouter = router
            } else {
                AppEnvironment.shared.authorizedRouter = nil
            }
        }
    }
}
