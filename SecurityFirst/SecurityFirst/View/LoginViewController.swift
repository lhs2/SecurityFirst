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
import SwitchLanguage
import KeychainSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var login: BorderUIButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerButton: BorderUIButton!
    
    let allLanguage = Language.getAllLanguages()
    var loginModel = LoginViewModel()
    let keychain = KeychainSwift()
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        Language.delegate = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.setupBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupView()
        
    }
    
    // Setup and Bind View
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
        
        emailTextField.placeholder = "Email".localized(using: "Localizable")
        passwordTextField.placeholder = "Password".localized(using: "Localizable")
        registerLabel.text = "Create label".localized(using: "Localizable")
        login.setTitle("Login".localized(using: "Localizable"), for: .normal)
        registerButton.setTitle("Create button".localized(using: "Localizable"), for: .normal)
        
    }
    
    
    // Actions
    @IBAction func loginRequest(_ sender: Any) {
        handleLoading(true)
        loginModel.attemptToLogin { (success, message) in
            if success && message == "not equal email"{
                let title = "Warning".localized(using: "Localizable")
                let message = "Not Equal Email".localized(using: "Localizable")
                self.handleLoading(false)
               self.notEqualEmail(title, message)
            } else if success {
                self.performSegue(withIdentifier: "goToHome", sender: self)
            } else {
                self.handleLoading(false)
              self.showAlert(title: "Error", message: message)
                
            }
        }
        
    }
    
    
    //Helper
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
    func notEqualEmail(_ title: String,_ message: String ) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
         self.handleLoading(true)
         self.loginModel.clearData()
         self.performSegue(withIdentifier: "goToHome", sender: self)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    // Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension UIViewController : LanguageDelegate {
    public func language(_ language: Language.Type, getLanguageFlag flag: UIImage) {
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
   
    
}
