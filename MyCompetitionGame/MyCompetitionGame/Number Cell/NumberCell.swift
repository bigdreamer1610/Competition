//
//  NumberCell.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/9/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
protocol NumberCellDelegate: AnyObject {
    func didTapButton(with index: Int)
}
class NumberCell: UICollectionViewCell {

    var delegate: NumberCellDelegate?
    var index = 0
    @IBOutlet var btnNum: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "NumberCell", bundle: nil)
    }
    
    func setUpCell(with data: NumberButton){
        btnNum.setTitle(data.name, for: .normal)
    }

    @IBAction func clickNumber(_ sender: UIButton) {
        delegate?.didTapButton(with: index)
        print(index)
    }
}
