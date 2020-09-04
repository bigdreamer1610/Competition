//
//  QuestionCell.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit


class QuestionCell: UITableViewCell {

    @IBOutlet var lbQuestion: UILabel!
    
    @IBOutlet var optionD: UILabel!
    @IBOutlet var optionC: UILabel!
    @IBOutlet var optionB: UILabel!
    @IBOutlet var optionA: UILabel!
    @IBOutlet var btnD: UIButton!
    @IBOutlet var btnC: UIButton!
    @IBOutlet var btnB: UIButton!
    @IBOutlet var btnA: UIButton!
    var quesid: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(data: Question){
        lbQuestion.text = "Question: \(data.content)"
        quesid = data.questionid
        setOptionValue(opA: data.falseAns1, opB: data.falseAns2, opC: data.falseAns3, opD: data.trueAns)
        setButtonState(stateA: false, stateB: false, stateC: false, stateD: false)
    }
    
    func setOptionValue(opA: String, opB: String, opC: String, opD: String){
        optionA.text = opA
        optionB.text = opB
        optionC.text = opC
        optionD.text = opD
    }
    
    @IBAction func chooseOption(_ sender: UIButton) {
        if sender.tag == 1 {
            setButtonState(stateA: true, stateB: false, stateC: false, stateD: false)
        } else if sender.tag == 2 {
            setButtonState(stateA: false, stateB: true, stateC: false, stateD: false)
        } else if sender.tag == 3 {
            setButtonState(stateA: false, stateB: false, stateC: true, stateD: false)
        } else if sender.tag == 4 {
            setButtonState(stateA: false, stateB: false, stateC: false, stateD: true)
        }
    }
    
    func setButtonState(stateA: Bool,stateB: Bool,stateC: Bool,stateD: Bool){
        btnA.isSelected = stateA
        btnB.isSelected = stateB
        btnC.isSelected = stateC
        btnD.isSelected = stateD
    }
}
