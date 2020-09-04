//
//  QuestionCell.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate: AnyObject {
    func didTapButton(with title: String, cateid: Int)
}

class CategoryCell: UITableViewCell {

    @IBOutlet var btnTakeTest: UIButton!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var lbName: UILabel!
    var cateid: Int = 0
    
    var delegate: CategoryCellDelegate?
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
        cateid = data.categoryid
    }

    
    @IBAction func clickTakeTest(_ sender: Any) {
        delegate?.didTapButton(with: "Take", cateid: cateid)
    }
    @IBAction func clickView(_ sender: Any) {
        delegate?.didTapButton(with: "View", cateid: cateid)
    }
}
