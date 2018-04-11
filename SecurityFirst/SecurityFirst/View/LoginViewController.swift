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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.setupBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
        
    }
    
    @IBAction func loginRequest(_ sender: Any) {
        loginModel.attemptToLogin { (success, message) in
            if success {
                self.performSegue(withIdentifier: "goToHome", sender: self)
            } else {
              self.showAlert(title: "Erro", message: message)
            }
        }
        
    }
    
    func setupBind() {
        _ = emailTextField.rx.text
            .orEmpty
            .bind(to: loginModel.email)
        
        
        _ = passwordTextField.rx.text
            .orEmpty
            .bind(to: loginModel.password)
        
        _ = loginModel.isValidLogin.map { $0 }
            .bind(to: login.rx.isEnabled)
    }
    
    func setupView(){
        
        emailTextField.placeholder = "Email22"
        passwordTextField.placeholder = "Senha22"
        login.setTitle("Logar22", for: .normal)
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
