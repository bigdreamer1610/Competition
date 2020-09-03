//
//  QuestionCell.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet var btnTakeTest: UIButton!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUp(data: Category) {
        lbName.text = data.name
    }
}
