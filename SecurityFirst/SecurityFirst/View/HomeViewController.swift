//
//  HomeViewController.swift
//  SecurityFirst
//
//  Created by de Sousa, Luiz H. on 11/04/2018.
//  Copyright © 2018 de Sousa, Luiz H. All rights reserved.
//

import UIKit
import KeychainSwift
import SwitchLanguage
import ReactiveKit
import Bond
import RxSwift
import Toast_Swift

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var keychain = KeychainSwift()
    var homeModel = HomeViewModel()
    
    override func viewDidLoad() {
        handleLoading(false)
        Language.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        homeModel.initDatabase()
        
        homeModel.accountList
            .bind(to: tableView, animated: true) {
                dataSource, indexPath, tableView in
                
                if indexPath.row == 0 {
                    let cell = Bundle.main.loadNibNamed("DetailedCell", owner: self, options: nil)?.first as! DetailedCell
                    cell.selectionStyle = .none ;
                    _ = self.homeModel.login
                        .asObservable()
                        .map { text -> String? in
                            return Optional(text)
                        }
                        .bind(to: cell.usernameLabel.rx.text)
                    
                    _ = self.homeModel.password
                        .asObservable()
                        .map { text -> String? in
                            return Optional(text)
                        }
                        .bind(to: cell.passwordButton.rx.title())
                    
                    cell.passwordButton.addTarget(self, action: #selector(self.passwordHandler), for: .touchUpInside )
                    
                    _ = self.homeModel.url
                        .asObservable()
                        .map { text -> String? in
                            return Optional(text)
                        }
                        .bind(to: cell.urlLabel.rx.text)
                    
                    _ = self.homeModel.imageButton
                        .asObservable()
                        .map { image -> UIImage? in
                            return image.image
                        }
                        .bind(to: cell.logoButton.rx.backgroundImage())
                    
                    cell.logoButton.addTarget(self, action: #selector(self.openURL), for: .touchUpInside )
                    
                    cell.logoButton.setTitle("", for: .normal)
                    cell.titleLabel.text = "Information".localized(using: "Localizable")
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "URLItem", for: indexPath as IndexPath) as! URLItemCell
                    cell.selectionStyle = .none;
                    cell.URLLabel.text = self.homeModel.accountList[indexPath.row] as? String
                    return cell
                }
                
        }
        super.viewDidLoad()
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
    
    // Tableview datasource and delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("This will never be called.")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0) {
            self.homeModel.selectedRow(indexPath.row)
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("This will never be called.")
    }

    //Actions
    @IBAction func changeLanguage(_ sender: Any) {
        let alert = UIAlertController(title: "Change Language".localized(using: "Localizable"), message: "Please choose your preferred language".localized(using: "Localizable"), preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "English".localized(using: "Localizable"), style: .default, handler: { (action) in
          Language.setCurrentLanguage("en")
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Portuguese".localized(using: "Localizable"), style: .default, handler: { (action) in
            Language.setCurrentLanguage("pt-BR")
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Japanese".localized(using: "Localizable"), style: .default, handler: { (action) in
            Language.setCurrentLanguage("ja")
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(using: "Localizable"), style: .cancel , handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    @IBAction func addAccount(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Account".localized(using: "Localizable"),
                                      message: "Enter your account details".localized(using: "Localizable"),
                                      preferredStyle: .alert)
        
        // Login button
        let loginAction = UIAlertAction(title: "Add", style: .default, handler: { (action) -> Void in
            // Get TextFields text
            let username = alert.textFields![0].text
            let password = alert.textFields![1].text
            let url = alert.textFields![2].text
            if username != "" && password != "" && url != "" {
                self.homeModel.addNewAccount(url!, username!, password!)
                print(self.homeModel.accountList, self.homeModel.accountList.count)
            } else {
                self.view.makeToast("Missing Fields".localized(using: "Localizable"))
            }
            
            
        })
        
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        
        // Add 1 textField (for username)
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .no
            textField.placeholder = "Username".localized(using: "Localizable")
        }
        
        
        // Add 2nd textField (for password)
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .no
            textField.placeholder = "Password".localized(using: "Localizable")
            textField.isSecureTextEntry = true
        }
        
        
        // Add 3rd textField (for phone no.)
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .no
            textField.placeholder = "URL"
        }
        
        
        // Add action buttons and present the Alert
        alert.addAction(loginAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func passwordHandler(sender: UIButton!) {
        let result = self.homeModel.handlePasswordButton()
        if result != "" {
            self.view.makeToast(result)
        }
    }
    
    @objc func openURL() {
        let error = "Can't open the url".localized(using: "Localizable")
        if let url = URL(string: homeModel.url.value),
            let httpURL = URL(string: "https:\\" + homeModel.url.value){
            do {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
                else if UIApplication.shared.canOpenURL(httpURL) {
                    UIApplication.shared.open(url, options: [:])
                }
                else {
                    self.view.makeToast(error)
                }
            }
        self.view.makeToast(error)
        }
    }
    
    // Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

   
}
