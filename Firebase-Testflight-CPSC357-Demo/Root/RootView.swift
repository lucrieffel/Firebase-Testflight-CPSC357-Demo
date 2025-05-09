//
//  RootView.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI

// The main entry point for determining and displaying the correct screen based on app state.
struct RootView: View {
    // Reads the app's current state from persistent storage (UserDefaults via AppStorage).
    @AppStorage("appState") var appStateEnum: AppStateEnum?
    
    // Holds the current state locally within the view.
    @State private var currentAppState: AppStateEnum = .unknown
    
    @ObservedObject private var appEnv = AppEnvironment.shared
    
    var body: some View {
        Group {
            // Conditionally render views based on the current app state.
            switch currentAppState {
            case .authorized:
                // User is authenticated – show main content using routing.
                RoutingView(authorizedRouter.self) { router in
                    ContentView()
                }
                .onAppear {
                    setupNotificationObservers()
                    // Handle any pending notification actions
                    processPendingNotificationAction()
                }
            case .unauthorized:
                // User is not authenticated – show the login screen.
                RoutingView(UnAuthorizedRouter.self) { router in
                    LoginView()
                }
                
            case .unknown:
                // Still determining the app state – show a loading screen.
                LoadingScreen()
            }
        }
        .present(isPresented: $appEnv.showNetworkError, type: .toast, position: .top, closeOnTap: true, onTap: {
            appEnv.errorMessage = ""
        }, onToastDismiss: {
            appEnv.errorMessage = ""
        }, view: {
            createNetworkErrorToastView()
                .opacity(appEnv.showNetworkError ? 1 : 0)
                .background(GeometryReader { geometry in
                    Color.clear.onAppear {
                        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                        if let window = window {
                            let safeAreaInsets = EdgeInsets(
                                top: window.safeAreaInsets.top,
                                leading: window.safeAreaInsets.left,
                                bottom: window.safeAreaInsets.bottom,
                                trailing: window.safeAreaInsets.right
                            )
                            // Apply safe area insets to the toast view
                            DispatchQueue.main.async {
                                _ = createNetworkErrorToastView().safeAreaInsets(safeAreaInsets)
                            }
                        }
                    }
                })
        })
        // React to changes in app state from persistent storage.
        .onChange(of: appStateEnum) { oldValue, newValue in
            if let newValue {
                currentAppState = newValue
                // Re-schedule notifications if user becomes authorized.
                if newValue == .authorized {
//                    print("🚀 scheduleNotification triggers")
//                    NotificationHelper.shared.registerForPushNotifications()
//                    NotificationHelper.shared.scheduleNotifications()
                } else if newValue == .unauthorized {
                    UserData.shared.pendingNotificationAction = nil // To remove pending notification identity
                }
            }
        }
        // Listen for global navigation events sent through NotificationCenter.
        .onReceive(NotificationCenter.default.publisher(for: .navigateToScreen)) { notification in
            // If the notification contains a valid routing target, navigate to it.
            if let target = notification.object as? authorizedRouter {
                if let router = AppEnvironment.shared.authorizedRouter {
                    router.routeTo(target)
                } else {
                    UserData.shared.pendingNotificationAction = target
                }
            }
        }
        .onAppear {
            NetworkMonitor.shared.observeNetwork { isNetworkConnected in
                DispatchQueue.main.async {
                    appEnv.showNetworkError = isNetworkConnected == false
                }
                
                if isNetworkConnected {
                    // Syncing all offline data if Internet Connected
                    //                    syncAllOfflineData()
                }
            }
        }
    }
    
    // Set up observers for app state changes
    private func setupNotificationObservers() {
        // Add notification observers for application state changes
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [self] _ in
            // App is coming back to foreground, check for pending actions
            processPendingNotificationAction()
        }
        
        // Listen for requests to process pending notifications (useful when app becomes active)
        NotificationCenter.default.addObserver(
            forName: .dismissAllSheets,
            object: nil,
            queue: .main
        ) { _ in
            // If we have a pending navigation action, process it after dismissing sheets
            if UserData.shared.pendingNotificationAction != nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.processPendingNotificationAction()
                }
            }
        }
    }
    
    // Process any pending notification actions
    private func processPendingNotificationAction() {
        if let pendingTarget = UserData.shared.pendingNotificationAction,
           let router = AppEnvironment.shared.authorizedRouter {
            // Clear the pending action first to prevent duplicate navigations
            UserData.shared.pendingNotificationAction = nil
            
            // Delay slightly to ensure views are fully loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                router.routeTo(pendingTarget)
            }
        }
    }
    
    func createNetworkErrorToastView() -> some View {
        VStack {
            Spacer(minLength: 8)
            HStack() {
                Spacer()
                Text(appEnv.errorMessage == "" ? "No Internet Connection" : appEnv.errorMessage)
                    .foregroundColor(.white)
                    .font(.system(size: 13, weight: .regular))
                    .multilineTextAlignment(.center)
                Spacer()
            }.padding(10)
        }
        .frame(height: 60)
        .background(appEnv.errorMessage == "" ? Color.red : Color.orange)
    }
}

