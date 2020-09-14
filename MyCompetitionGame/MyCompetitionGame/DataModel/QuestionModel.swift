//
//  QuestionModel.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/9/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation

class QuestionModel {
    var question: Question?
    var playerArr = [Int](repeating: 0, count: 4)
    var falseOptions = [String]()
    var optionIndex = [Int]()
    var trueOption = ""
    var buttonStates = [Bool](repeating: false, count: 4)
    var hasAnswer = false
}
