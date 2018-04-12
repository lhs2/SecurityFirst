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

class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var keychain = KeychainSwift()
    var URLs: [String] = []
    var currentSelect = 1
    override func viewDidLoad() {
        handleLoading(false)
        Language.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
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
        if(self.URLs.count > 0) {
            if(indexPath.row == 0) {
                let cell = Bundle.main.loadNibNamed("DetailedCell", owner: self, options: nil)?.first as! DetailedCell
                keychain.getData("URLs")
                cell.titleLabel.text = ""
                cell.titleLabel.text = ""
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "URLItem", for: indexPath as IndexPath) as! URLItemCell
                cell.URLLabel.text = self.URLs[indexPath.row-1]
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "URLItem", for: indexPath as IndexPath) as! URLItemCell
            cell.URLLabel.text = "No Data".localized(using: "Localizable")
            return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.URLs.count + 1
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
    
    // Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
   
}
