//
//  DetailedCell.swift
//  SecurityFirst
//
//  Created by de Sousa, Luiz H. on 11/04/2018.
//  Copyright © 2018 de Sousa, Luiz H. All rights reserved.
//

import UIKit

class DetailedCell: UITableViewCell {

    @IBOutlet weak var logoButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
