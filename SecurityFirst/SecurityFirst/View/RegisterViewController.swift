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
    
    // Setup and Bind View
    func setupView(){

        self.title = "Register title".localized(using: "Localizable")
        nameTextField.placeholder = "Username".localized(using: "Localizable")
        passwordTextField.placeholder = "Password".localized(using: "Localizable")
        mailTextField.placeholder = "Email".localized(using: "Localizable")
        register.setTitle("Sign Up".localized(using: "Localizable"), for: .normal)
        
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
    // Helper
    func handleLoading(_ start: Bool) {
        if start {
            Loading.start()
            self.view.isUserInteractionEnabled = false
            self.view.alpha = 0.6
            self.navigationController?.navigationBar.alpha = 0.6
        } else {
            Loading.stop()
            self.view.isUserInteractionEnabled = true
            self.view.alpha = 1
            self.navigationController?.navigationBar.alpha = 1
            
        }
        
    }
   // Actions
    @IBAction func registerRequest(_ sender: Any) {
        handleLoading(true)

        registerModel.attemptToRegister() { (success, message) in
            if success {
                self.performSegue(withIdentifier: "goToHome", sender: self)
            } else {
                self.showAlert(title: "Erro", message: message)
                self.handleLoading(false)

            }
        }
    }
    
    // Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
