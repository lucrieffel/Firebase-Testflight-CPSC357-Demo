//
//  User.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//

import Foundation
import SwiftData
import Firebase //uncomment if you want to use the firebase timestamp type

struct User: Identifiable, Codable, Hashable {
    var id: String { userID }
    let userID: String
    let fullname: String
    let email: String
    var userType: UserType?
    let dateCreated: Date? //
    var points: Int = 0
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
    
    init(userID: String, fullname: String, email: String, userType: UserType?, dateCreated: Date) {
        self.userID = userID
        self.fullname = fullname
        self.email = email
        self.userType = userType
        self.dateCreated = dateCreated
        self.points = 0
    }
    
    init(from data: [String: Any]) throws {
        guard
            let userID = data["userID"] as? String,
            let fullname = data["fullname"] as? String,
            let email = data["email"] as? String,
            let userType = data["userType"] as? String,
            let points = data["points"] as? Int
        else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data"])
        }
        
        // Handle Firebase Timestamp conversion
        let dateCreated: Date
        if let timestamp = data["dateCreated"] as? Timestamp {
            dateCreated = timestamp.dateValue()
        } else if let date = data["dateCreated"] as? Date {
            dateCreated = date
        } else {
            dateCreated = Date()
            print("WARNING: Could not parse dateCreated field, using current date instead")
        }
        
        self.userID = userID
        self.fullname = fullname
        self.email = email
        self.userType = UserType(rawValue: userType)
        self.dateCreated = dateCreated
        self.points = points
    }
}


//User Type enum
enum UserType: String, Codable {
    case customer
    case business
    case admin
    case government
}
