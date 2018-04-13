//
//  RegisterViewModel.swift
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

class RegisterViewModel: ReactiveCompatible {
    
    
    let email = Variable<String>("")
    let password = Variable<String>("")
    let username = Variable<String>("")
    let isValidRegister: Observable<Bool>
    
    let keychain = KeychainSwift()
    
    init() {
        isValidRegister = Observable.combineLatest( self.email.asObservable(),
                                                    self.password.asObservable(),
                                                    self.username.asObservable()) {
                                                    (email,password, username) in
            return    email.count > 0
                && password.count > 0
                && username.count > 0
        }
    }
    
    let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let basePasswordPattern = "(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9]).{"
    
    func isValidRegex(_ testStr:String, _ pattern: String                ) -> Bool {
        let Test = NSPredicate(format:"SELF MATCHES %@", pattern)
        return Test.evaluate(with: testStr)
    }
    
    func attemptToRegister( handler: @escaping ((_ success: Bool, _ message: String)->Void)) {
        let passwordPattern = basePasswordPattern + String(password.value.count) + "}"
        if !isValidRegex(email.value, emailPattern) {
            handler(false, "Email invalido")
        } else if !isValidRegex(password.value, passwordPattern) {
            handler(false, "Senha fraca. Maiuscula, Numero, Caractere especial e 8 digitos são necessarios.")
        } else {
            let params: [String: Any] = [
                "email": email.value,
                "password": password.value,
                "username": username.value
            ]
            APIManager.sharedInstance.request( .post, .SignUp, nil, params) { (status, message) in
                if(status){
                    self.clearData()
                    handler(true, message)
                } else {
                    handler(false, message)
                }
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

