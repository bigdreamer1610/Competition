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
    var account: String
    var typeid: Int
    
    init(id: Int, account: String, typeid: Int) {
        self.id = id
        self.account = account
        self.typeid = typeid
    }
}
