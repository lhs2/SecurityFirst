//
//  RegisterViewController.swift
//  SecurityFirst
//
//  Created by de Sousa, Luiz H. on 09/04/2018.
//  Copyright © 2018 de Sousa, Luiz H. All rights reserved.
//

import UIKit
import TextFieldEffects
import Bond
import ReactiveKit

class RegisterViewController: UIViewController {
   
    var registerModel = RegisterViewModel()
    
    @IBOutlet weak var nameTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var mailTextField: HoshiTextField!
    @IBOutlet weak var register: BorderUIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBind()
        setupView()
    }
    
    
    func setupView(){
        self.title = "CADASTRO"
    }
    
    func setupBind() {
        _ = mailTextField.rx.text
            .orEmpty
            .bind(to: registerModel.email)
        
        
        _ = passwordTextField.rx.text
            .orEmpty
            .bind(to: registerModel.password)
        
        _ = nameTextField.rx.text
            .orEmpty
            .bind(to: registerModel.username)
        
        _ = registerModel.isValidRegister.map { $0 }
            .bind(to: register.rx.isEnabled)
    }
   
    @IBAction func registerRequest(_ sender: Any) {
        registerModel.attemptToRegister() { (success, message) in
            if success {
                self.performSegue(withIdentifier: "goToHome", sender: self)
            } else {
                self.showAlert(title: "Erro", message: message)
            }
        }
    }
    
}
