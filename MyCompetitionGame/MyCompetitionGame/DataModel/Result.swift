//
//  Result.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation

struct Result: Codable {
    var resultid: Int
    var accountid: Int
    var categoryid: Int
    var result: Int
    var duration: Int
    var time: Date
    
    init(resultid: Int,accountid: Int,categoryid: Int, result: Int,duration: Int, time: Date) {
        self.resultid = resultid
        self.accountid = accountid
        self.categoryid = categoryid
        self.result = result
        self.duration = duration
        self.time = time
    }
    
}
