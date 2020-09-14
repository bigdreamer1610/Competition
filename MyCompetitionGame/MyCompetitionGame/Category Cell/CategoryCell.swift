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

class CategoryCell: BaseTBCell {

    @IBOutlet var backView: UIView!
    @IBOutlet var cateImage: UIImageView!
    @IBOutlet var btnTakeTest: UIButton!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var lbName: UILabel!
    var cateid: Int = 0
    
    var delegate: CategoryCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        customizeButton()
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
    
    func customizeButton(){
        btnView.layer.cornerRadius = 10
        btnView.layer.borderWidth = 1
        btnView.layer.borderColor = UIColor.black.cgColor
        
        btnTakeTest.layer.cornerRadius = 10
        btnTakeTest.layer.borderWidth = 1
        btnTakeTest.layer.borderColor = UIColor.black.cgColor
        
        //backView
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOpacity = 0.8
        backView.layer.shadowOffset = .zero
        
        /*
         yourView.layer.shadowColor = UIColor.black.cgColor
         yourView.layer.shadowOpacity = 1
         yourView.layer.shadowOffset = .zero
         yourView.layer.shadowRadius = 10
         */
    }
}
