//
//  LoginViewModel.swift
//  FirebasePhoneAuth
//
//  Created by Md Shah Alam on 8/1/22.
//

import SwiftUI
import Firebase

class LoginViewModel: ObservableObject {
    @Published var phNo = ""
    @Published var code = ""
    
    // DataModel for error view...
    @Published var errorMsg = ""
    @Published var error = false
    
    // Storing CODE for verification...
    @Published var CODE = ""
    @Published var gotoVerify = false
    
    // User logged status
    @AppStorage("log_Status") var status = false
    
    // Loading View...
    @Published var loading = false
    
    // Getting country Phone Code...
    func getCountryCode() -> String {
        
        let regionCode = Locale.current.regionCode ?? ""
        
        return countries[regionCode] ?? ""
    }
    
    // Sending code to user...
    func sendCode() {
        
        //enabaling testing code...
        // disable when you need to test with real device...
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        let number = "+\(getCountryCode())\(phNo)"
        
        PhoneAuthProvider.provider().verifyPhoneNumber(number, uiDelegate: nil) { CODE, err in
            if let error = err {
                self.errorMsg = error.localizedDescription
                withAnimation {
                    self.error.toggle()
                }
                return
            }
            self.CODE = CODE ?? ""
            self.gotoVerify = true
        }
    }
    
    func verifyCode() {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.CODE, verificationCode: code)
        
        loading = true
        
        Auth.auth().signIn(with: credential) { result, err in
            self.loading = false
            if let error = err{
                self.errorMsg = error.localizedDescription
                withAnimation {
                    self.error.toggle()
                }
                return
            }
            // else user logged in Successfully...
            withAnimation{self.status = true}
        }
    }
    
    func requestCode(){
        sendCode()
        withAnimation {
            self.errorMsg = "Code Sent Successfully !!!"
            self.error.toggle()
        }
    }
}
