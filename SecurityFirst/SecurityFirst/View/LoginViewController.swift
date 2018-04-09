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
        loginModel.attemptToLogin(self) { (success, message) in
            if success {
              self.showAlert(title: "Faz segue", message: message)
            } else {
              self.showAlert(title: "Erro", message: message)
            }
        }
        
    }
    
    
    
}

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
