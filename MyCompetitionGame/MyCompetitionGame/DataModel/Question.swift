//
//  Question.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation

struct Question: Codable {
    var questionid: Int
    var categoryid: Int
    var content: String
    var trueAns: String?
    var falseAns1: String?
    var falseAns2: String?
    var falseAns3: String?
    var options: [String:String] = [String:String]()
    
    init(questionid: Int,categoryid: Int, content: String,trueAns: String,falseAns1: String,falseAns2: String,falseAns3: String) {
        self.questionid = questionid
        self.categoryid = categoryid
        self.content = content
        self.trueAns = trueAns
        self.falseAns1 = falseAns1
        self.falseAns2 = falseAns2
        self.falseAns3 = falseAns3
        self.options["true"] = trueAns
        self.options["false1"] = falseAns1
        self.options["false2"] = falseAns2
        self.options["false3"] = falseAns3
    }
}
