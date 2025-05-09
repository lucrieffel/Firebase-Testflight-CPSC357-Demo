//
//  LogoView.swift
//  Firebase-Testflight-CPSC357-Demo
//
//  Created by Luc Rieffel on 5/9/25.
//
import SwiftUI

struct LogoImage: View {
    var body: some View {
        
       VStack(alignment: .center) {
           Image("logo-placeholder")
               .resizable()
               .aspectRatio(contentMode: .fit)
               .frame(width: 100, height: 100)
               .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            
        Text("Logo-Placeholder")
               .font(.title2)
            .fontWeight(.black)
       }
    }
}

#Preview {
    LogoImage()
}
