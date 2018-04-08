//
//  LoginViewController.swift
//  SecurityFirst
//
//  Created by de Sousa, Luiz H. on 08/04/2018.
//  Copyright © 2018 de Sousa, Luiz H. All rights reserved.
//

import UIKit
import TextFieldEffects
import Bond
import ReactiveKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var login: BorderUIButton!
    
    var loginModel = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = emailTextField.rx.text
            .orEmpty
            .bind(to: loginModel.email)
        
        
        _ = passwordTextField.rx.text
            .orEmpty
            .bind(to: loginModel.password)
        
        _ = loginModel.isValidLogin.map { $0 }
            .bind(to: login.rx.isEnabled)
        
    }
    @IBAction func loginRequest(_ sender: Any) {
        print("enable", loginModel.email.value, loginModel.password.value )
        
    }
    
    
    
}
