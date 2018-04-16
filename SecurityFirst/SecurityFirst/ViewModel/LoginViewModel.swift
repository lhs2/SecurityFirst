//
//  LoginViewModel.swift
//  SecurityFirst
//
//  Created by de Sousa, Luiz H. on 08/04/2018.
//  Copyright © 2018 de Sousa, Luiz H. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa
import Alamofire
import KeychainSwift

class LoginViewModel: ReactiveCompatible {
    
    
    let email = Variable<String>("")
    let password = Variable<String>("")
    let isValidLogin: Observable<Bool>
    
    let keychain = KeychainSwift()
    
    init() {
        isValidLogin = Observable.combineLatest(self.email.asObservable(), self.password.asObservable())
        { (email, password) in
            return email.count > 0
                && password.count > 0
        }
    }
    
    let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    //let passwordPattern = "^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,}$"

    func isValidRegex(_ testStr:String, _ pattern:String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", pattern)
        return test.evaluate(with: testStr)
    }
    
    func attemptToLogin( handler: @escaping ((_ success: Bool, _ message: String)->Void)) {
        let params: [String: Any] = [
            "email": email.value,
            "password": password.value,
        ]
        
        APIManager.sharedInstance.request( .post, .signIn, nil, params) { (status, message) in
            if(status){
                let lastLogin = self.keychain.get("lastLogin")
                if(lastLogin != nil && lastLogin != self.email.value) {
                    handler(true,"not equal email")
                }
                handler(true, message)
            } else {
                handler(false, message)
            }
        }
        
    }
    
    func clearData() {
        let token = keychain.get("token")
        keychain.clear()
        keychain.set(token!, forKey: "token")
        keychain.set(email.value,forKey: "lastLogin")
    }

}

