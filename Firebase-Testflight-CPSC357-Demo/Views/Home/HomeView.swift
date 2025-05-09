//
//  HomeView.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//
import SwiftUI

struct HomeView: View {
    // Mock data
    private let recentActivities = [
        "Completed workout session",
        "Added new contact",
        "Updated profile information",
        "Reached daily goal"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Welcome section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome Back!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Here's your activity summary")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Dashboard cards
                    dashboardCards
                    
                    // Recent activity
                    recentActivitySection
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
        }
    }
    
    private var dashboardCards: some View {
        VStack(spacing: 15) {
            // Progress card
            cardView(title: "Today's Progress", icon: "chart.bar.fill") {
                VStack(alignment: .leading, spacing: 8) {
                    ProgressView(value: 0.7)
                        .tint(.blue)
                    Text("70% of daily goal completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Stats card
            cardView(title: "Weekly Stats", icon: "calendar") {
                HStack {
                    statItem(value: "12", label: "Sessions")
                    Divider().frame(height: 40)
                    statItem(value: "85%", label: "Avg. Score")
                    Divider().frame(height: 40)
                    statItem(value: "5", label: "Achievements")
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var recentActivitySection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Activity")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(recentActivities, id: \.self) { activity in
                HStack {
                    Circle()
                        .fill(.blue)
                        .frame(width: 8, height: 8)
                    Text(activity)
                        .font(.subheadline)
                    Spacer()
                    Text("Today")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            }
        }
    }
    
    private func cardView<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            content()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func statItem(value: String, label: String) -> some View {
        VStack {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
}
