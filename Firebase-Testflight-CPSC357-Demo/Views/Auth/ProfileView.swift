//
//  ProfileView.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI
import UIKit

struct ProfileView: View {
    @State private var showingSheet = false
    @State private var showingLogoutAlert = false
    @State private var isLoggingOut = false
    @State private var showThresholdSheet = false
    @State private var showOfflineDataSheet = false
    
    var body: some View {
        ZStack {
            ColorType.darkBlue.color.opacity(0.05)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Profile header section
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .foregroundColor(ColorType.darkBlue.color)
                            .clipShape(Circle())
                            .shadow(color: Color.primary.opacity(0.1), radius: 8, x: 0, y: 4)
                            .padding(.top, 24)
                        
                        if let userName = AppEnvironment.shared.authViewModel.currentUser?.fullname {
                            Text(userName)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(AppEnvironment.shared.authViewModel.currentUser?.email ?? "user@email.com")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        } else {
                            Text("User")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 16)
                    
                    // Profile options in cards
                    VStack(spacing: 16) {
                        profileOptionCard(title: "Change Password", icon: "key.fill", action: {
                            // Haptic feedback
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            
                            print("Change Password selected")
                            showingSheet.toggle()
                        })
                        .sheet(isPresented: $showingSheet) {
                            ResetPasswordForm()
                        }
                        
                        profileOptionCard(title: "Log Out", icon: "arrow.left.circle.fill", iconColor: .white, backgroundColor: .red,  action: {
                            // Haptic feedback
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            print("Log Out selected")
                            showingLogoutAlert = true
                        })
                        
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 24)
            }
            
            if isLoggingOut {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                                .padding(.bottom, 10)
                            
                            Text("Signing Out...")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    )
                    .transition(.opacity)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .disabled(isLoggingOut)
        .alert("Sign Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                performSignOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }
    
    private func performSignOut() {
        withAnimation {
            isLoggingOut = true
        }
        
        // Haptic feedback for logout
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Add a delay to show the animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            AppEnvironment.shared.authViewModel.signOut()
            UserData.shared.appStateEnum = .unauthorized
        }
    }
    
    // Helper function to create consistent profile option cards
    private func profileOptionCard(title: String, icon: String, iconColor: Color? = nil, backgroundColor: Color? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 36, height: 36)
                    .foregroundColor(iconColor)
                    .background(backgroundColor ?? Color(.systemGray5))
                    .clipShape(Circle())
                    .padding(.trailing, 4)
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.primary.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Helper function to create consistent Slider option cards
    private func thresholdOptionCard(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 36, height: 36)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
                    .padding(.trailing, 4)
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.primary.opacity(0.05), radius: 5, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview {
//    ProfileView()
//}
