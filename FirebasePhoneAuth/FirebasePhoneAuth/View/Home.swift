//
//  Home.swift
//  FirebasePhoneAuth
//
//  Created by Md Shah Alam on 8/10/22.
//

import SwiftUI
import Firebase

struct Home: View {
    
    @AppStorage("log_Status") var status = false
    
    var body: some View {
        VStack(spacing: 15){
            // Home View...
            Text("Logged In Successfully")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.black)
            
            Button {
                // logging out...
                do{
                    try Auth.auth().signOut()
                }
                catch{
                    print("already logged out")
                }
                withAnimation {
                    status = false
                }
                
            } label: {
                Text("LogOut")
                    .fontWeight(.heavy)
            }

        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
