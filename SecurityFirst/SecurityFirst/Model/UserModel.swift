//
//  UserModel.swift
//  SecurityFirst
//
//  Created by de Sousa, Luiz H. on 08/04/2018.
//  Copyright © 2018 de Sousa, Luiz H. All rights reserved.
//

import Foundation
import RxSwift

struct UserModel {
    var email: String = ""
    var password: String = ""
    var url: String = ""
    init(_ email: String, _ password: String, _ url: String) {
        self.email = email
        self.password = password
        self.url = url
    }
    
}
