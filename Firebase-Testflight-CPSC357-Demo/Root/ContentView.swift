//
//  ContentView.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var trigger = false
    @State private var authenticated = false
    @State private var selectedTab = 0 //tab number for tabview
    
    var body: some View {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Dashboard", systemImage: "list.bullet")
                    }
                    .tag(0)
                
                CommunityView()
                    .tabItem{
                        Label("Contacts", systemImage: "person.2")
                    }
                    .tag(1)
                
 
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                    .tag(2)
            }
            .toolbarBackground(.visible, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
