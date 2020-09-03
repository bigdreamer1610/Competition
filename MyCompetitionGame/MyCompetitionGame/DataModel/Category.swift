//
//  Category.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation

struct Category {
    var categoryid: Int
    var name: String
    
    init(categoryid: Int, name: String) {
        self.categoryid = categoryid
        self.name = name
    }
}
