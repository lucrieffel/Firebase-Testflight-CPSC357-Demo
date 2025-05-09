//
//  Firebase_Testflight_CPSC357_DemoApp.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/6/25.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct Firebase_Testflight_CPSC357_DemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase
    //MARK: Swift Data Model container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            GeometryReader {proxy in
                RootView() //we use RootView instead to handle navigation routing, ContentView handles all authorized/authenticated user navigations
            }
        }
        .modelContainer(sharedModelContainer)
        //Show the app's state
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                print("📱 App became active (SwiftUI lifecycle)")
            case .inactive:
                print("📱 App became inactive (SwiftUI lifecycle)")
            case .background:
                print("📱 App entered background (SwiftUI lifecycle)")
            @unknown default:
                print("📱 Unknown scene phase")
            }
        }
    }
}

//MARK: -- Must add this section in your app entry point for firebase to work
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseConfiguration.shared.setLoggerLevel(.min)
      FirebaseApp.configure()

      return true
  }
}
