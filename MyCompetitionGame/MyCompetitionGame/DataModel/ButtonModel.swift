//
//  ButtonModel.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/9/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import Foundation

class ButtonModel {
    func getButtons(number: Int) -> [NumberButton]{
        var generateButton = [NumberButton]()
        for i in 1...number {
            let button = NumberButton()
            button.name = "\(i)"
            generateButton.append(button)
        }
        return generateButton
    }
}
