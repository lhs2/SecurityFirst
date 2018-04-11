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

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var login: BorderUIButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerButton: BorderUIButton!
    
     let allLanguage = Language.getAllLanguages()
    
    var loginModel = LoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            Language.setCurrentLanguage("en")
            Language.delegate = self
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
        
        emailTextField.placeholder = "Email".localized(using: "Localizable")
        passwordTextField.placeholder = "Password".localized(using: "Localizable")
        registerLabel.text = "Create label".localized(using: "Localizable")
        login.setTitle("Login".localized(using: "Localizable"), for: .normal)
        registerButton.setTitle("Create button".localized(using: "Localizable"), for: .normal)
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
