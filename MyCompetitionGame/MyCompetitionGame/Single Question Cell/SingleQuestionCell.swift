//
//  SingleQuestionCell.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class SingleQuestionCell: UITableViewCell {

    
    @IBOutlet var lbQuestion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeLayout()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpQuestion(data: Question){
        lbQuestion.text = data.content
    }
    
    func customizeLayout(){
    }
    
}
