//
//  Account.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation

struct Account: Codable {
    var id: Int
    var name: String
    var mail: String
    var facebookid: String
    var typeid: Int
    
    init(id: Int,name: String,mail: String,facebookid: String, typeid: Int) {
        self.id = id
        self.name = name
        self.mail = mail
        self.facebookid = facebookid
        self.typeid = typeid
    }

}
