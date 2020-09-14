//
//  Account.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation

struct Account: Codable {
    var id: Int = 0
    var name: String = ""
    var mail: String = ""
    var facebookid: String = ""
    var typeid: Int = 0
    var nickname: String = ""
    var limit: Int = 100
    
    init(id: Int,name: String,mail: String,facebookid: String, typeid: Int, nickname: String, limit: Int) {
        self.id = id
        self.name = name
        self.mail = mail
        self.facebookid = facebookid
        self.typeid = typeid
        self.nickname = nickname
        self.limit = limit
    }

}
