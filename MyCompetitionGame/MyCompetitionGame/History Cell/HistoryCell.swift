//
//  HistoryCell.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/7/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    
    @IBOutlet var lbTime: UILabel!
    @IBOutlet var lbDuration: UILabel!
    @IBOutlet var lbCategory: UILabel!
    @IBOutlet var lbScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData(with data: Result){
        lbScore.text = "Score: \(data.result)"
        lbCategory.text = "Category: \(data.categoryid)"
        lbDuration.text = "Duration: \(data.duration)"
        lbTime.text = "Taken time: \(data.time)"
        
    }
    
}
