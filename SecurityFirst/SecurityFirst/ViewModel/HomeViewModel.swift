//
//  HomeViewModel.swift
//  SecurityFirst
//
//  Created by de Sousa, Luiz H. on 11/04/2018.
//  Copyright © 2018 de Sousa, Luiz H. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import KeychainSwift
import Kingfisher
import Bond

class HomeViewModel: ReactiveCompatible {
    // Variable Data
    var imageButton = Variable<UIImageView>(UIImageView())
    var url = Variable<String>("")
    var login = Variable<String>("")
    var password = Variable<String>("")
    var accountList = MutableObservableArray([])
    // Helper
    let keychain = KeychainSwift()
    
    func updateAccountList() {
        let accountString = keychain.get("AccountList")
        self.accountList.removeAll()
        _ = separe(accountString!).map{
            self.accountList.append($0)
        }
        
    }
    
    func initDatabase() {
        var accountString = keychain.get("AccountList")
        accountString = accountString == nil ? "header" : accountString
        keychain.set(accountString!, forKey: "AccountList")
        updateAccountList()
    }
    
    func addNewAccount(_ url: String, _ login:String, _ password: String) {
        var accountString = keychain.get("AccountList")
        let currentLogin = keychain.get(url+"/login")
        if currentLogin != nil && currentLogin == login {
            keychain.set(password, forKey: url+"/senha")
        }
        else if currentLogin != nil {
            keychain.set(login, forKey: url+"/login")
            keychain.set(password, forKey: url+"/senha")
        }
        else {
            accountString = accountString != nil ? accountString!+"^"+url : url
            keychain.set(accountString!, forKey: "AccountList")
            keychain.set(login, forKey: url+"/login")
            keychain.set(password, forKey: url+"/senha")
        }
        updateAccountList()
    }
    
    func selectedRow(_ row: Int) {
        let url = self.accountList[row] as? String
        self.login.value = keychain.get(url!+"/login")!
        self.url.value = url!
        self.password.value = "******"
        self.imageButton.value = UIImageView(image: UIImage(named: "icons8-image")!)
        requestImage()
    }
    
    @objc func handlePasswordButton()->String {
        if(self.password.value == "******") {
            self.password.value = keychain.get(self.url.value+"/senha")!
            return "TouchID"
        } else {
            if(self.password.value != ""){
                UIPasteboard.general.string = self.password.value
                return "Password copied!".localized(using: "Localizable")
            }
        }
        return ""
    }
    
    func requestImage() {
        var pathP: [CVarArg] = []
        pathP.append(self.url.value as CVarArg)
        APIManager.sharedInstance.download(pathP) {
            sucess, data, message in
            if sucess {
                self.imageButton.value = UIImageView(image: UIImage(data: data) )
            } else {
                print(message)
            }

        }
    }
    
    func separe(_ item:String)->[String] {
        let components = item.components(separatedBy: "^")
        return components
    }
}

