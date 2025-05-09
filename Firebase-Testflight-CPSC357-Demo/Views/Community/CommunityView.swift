//
//  CommunityView.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import SwiftUI

struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String // System image name for avatar
    let status: String
    let lastActive: String
}

struct CommunityView: View {
    // Sample data
    private let contacts = [
        Contact(name: "Alex Johnson", avatar: "person.crop.circle.fill", status: "Online", lastActive: "Active now"),
        Contact(name: "Jamie Smith", avatar: "person.crop.circle.fill", status: "Busy", lastActive: "2h ago"),
    ]
    
    @State private var searchText = ""
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Contact list
                List {
                    Section(header: Text("Active Contacts")) {
                        ForEach(filteredContacts.filter { $0.status == "Online" }) { contact in
                            contactRow(contact)
                        }
                    }
                    
                    Section(header: Text("Other Contacts")) {
                        ForEach(filteredContacts.filter { $0.status != "Online" }) { contact in
                            contactRow(contact)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .searchable(text: $searchText, prompt: "Search contacts")
            .navigationTitle("Community")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action for adding a new contact
                    }) {
                        Image(systemName: "person.badge.plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("All Contacts", action: {})
                        Button("Online Only", action: {})
                        Button("Sort by Name", action: {})
                        Button("Sort by Activity", action: {})
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
    }
    
    private func contactRow(_ contact: Contact) -> some View {
        HStack {
            // Avatar with status indicator
            ZStack(alignment: .bottomTrailing) {
                Image(systemName: contact.avatar)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.blue)
                
                Circle()
                    .fill(statusColor(contact.status))
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(Color(.systemBackground), lineWidth: 2)
                    )
            }
            
            // Contact details
            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.headline)
                
                Text(contact.lastActive)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Action buttons
            HStack(spacing: 15) {
                Button(action: {
                    // Message action
                }) {
                    Image(systemName: "message.fill")
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    // Call action
                }) {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical, 4)
    }
    
    private func statusColor(_ status: String) -> Color {
        switch status {
        case "Online":
            return .green
        case "Busy":
            return .red
        case "Away":
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    CommunityView()
} 
