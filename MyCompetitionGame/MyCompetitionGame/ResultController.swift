//
//  ResultController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/4/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class ResultController: UIViewController {

    
    @IBOutlet var btnBackMenu: UIButton!
    @IBOutlet var lbScore: UILabel!
    var myScore: Int = 0
    var totalScore: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        lbScore.text = "\(myScore)/\(totalScore)"
        customizeLayout()
        // Do any additional setup after loading the view.
    }
    
    func customizeLayout(){
        btnBackMenu.layer.cornerRadius = 10
        btnBackMenu.layer.borderWidth = 1
        btnBackMenu.layer.borderColor = UIColor.black.cgColor
        
        lbScore.layer.cornerRadius = 10
        lbScore.backgroundColor = .clear
        lbScore.layer.borderColor = UIColor.green.cgColor
    }
    

}
