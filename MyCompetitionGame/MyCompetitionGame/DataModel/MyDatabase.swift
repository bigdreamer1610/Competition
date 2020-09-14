//
//  MyDatabase.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//


import Firebase
import FirebaseDatabase
class MyDatabase {
    static let ref = Database.database().reference()
    static let user = UserDefaults.standard
}

struct keys {
    static let name = "name"
    static let email = "email"
    static let facebookid = "fbid"
    static let typeid = "typeid"
    static let accountid = "accountid"
    static let nickname = "nickname"
    static let limit = "timelimit"
}
