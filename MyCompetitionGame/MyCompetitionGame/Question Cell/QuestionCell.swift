//
//  QuestionCell.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

protocol QuestionCellDelegate {
    func didChooseOption(with option: Int, with index: Int)
}

class QuestionCell: UITableViewCell {

    @IBOutlet var lbQuestion: UILabel!
    @IBOutlet var optionD: UILabel!
    @IBOutlet var optionC: UILabel!
    @IBOutlet var optionA: UILabel!
    
    @IBOutlet var optionB: UILabel!
    @IBOutlet var btnD: UIButton!
    @IBOutlet var btnC: UIButton!
    @IBOutlet var btnB: UIButton!
    @IBOutlet var btnA: UIButton!
    var quesid: Int = 0
    var options = [String]()
    var index: Int = 0
    var trueAnsIndex: Int = 0
    var delegate: QuestionCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //set up radio button
        btnA.imageView?.contentMode = .scaleAspectFit
        btnB.imageView?.contentMode = .scaleAspectFit
        btnC.imageView?.contentMode = .scaleAspectFit
        btnD.imageView?.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customizeLayout(){
        
    }
    
    func setUp(data: Question, index: Int){
        lbQuestion.text = "Question \(index + 1): \(data.content)"
        quesid = data.questionid
        options.append(data.falseAns1!)
        options.append(data.falseAns2!)
        options.append(data.falseAns3!)
        options.shuffle()
        switch trueAnsIndex {
        case 1:
            optionA.text = data.trueAns
            setFalseValue(lb1: optionB, lb2: optionC, lb3: optionD)
        case 2:
            optionB.text = data.trueAns
            setFalseValue(lb1: optionB, lb2: optionC, lb3: optionD)
        case 3:
            optionC.text = data.trueAns
            setFalseValue(lb1: optionB, lb2: optionC, lb3: optionD)
        default:
            optionD.text = data.trueAns
            setFalseValue(lb1: optionB, lb2: optionC, lb3: optionD)
        }
        setButtonState(stateA: false, stateB: false, stateC: false, stateD: false)
    }
    
    
    func setFalseValue(lb1: UILabel,lb2: UILabel, lb3: UILabel){
        lb1.text = options[0]
        lb2.text = options[1]
        lb3.text = options[2]
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
        delegate?.didChooseOption(with: sender.tag, with: index)
    }
    
    func setButtonState(stateA: Bool,stateB: Bool,stateC: Bool,stateD: Bool){
        btnA.isSelected = stateA
        btnB.isSelected = stateB
        btnC.isSelected = stateC
        btnD.isSelected = stateD
    }
    
    
}
