//
//  ResultController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/4/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit

class ResultController: UIViewController {

    
    @IBOutlet var lbHey: UILabel!
    @IBOutlet var btnBackMenu: UIButton!
    @IBOutlet var lbScore: UILabel!
    var myScore: Int = 0
    var totalScore: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        lbScore.text = "\(myScore)/\(totalScore)"
        lbHey.text = "Hey \(MyDatabase.user.string(forKey: keys.name)!)"
        customizeLayout()
        // Do any additional setup after loading the view.
    }
    
    func customizeLayout(){
        btnBackMenu.layer.cornerRadius = 10
        btnBackMenu.layer.borderWidth = 1
        btnBackMenu.layer.borderColor = UIColor.black.cgColor
        btnBackMenu.layer.masksToBounds = true
        
        //gradient
        //btnBackMenu.applyGradient(colors: [UIColorFromRGB(0x2B95CE).cgColor,UIColorFromRGB(0x2ECAD5).cgColor])
        
        lbScore.layer.cornerRadius = 10
        lbScore.backgroundColor = .clear
        lbScore.layer.borderColor = UIColor.green.cgColor
    }
    
    @IBAction func clickBack(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu_vc") as? MenuViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
     func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF)))/255.0, alpha: 1.0)
    }
    
    
    
}

extension UIButton {
    func applyGradient(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = 20

        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2.5, height: 2.5)
        gradientLayer.shadowRadius = 5.0
        gradientLayer.shadowOpacity = 0.3
        gradientLayer.masksToBounds = false

        self.layer.insertSublayer(gradientLayer, at: 0)
        self.contentVerticalAlignment = .center
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        self.titleLabel?.textColor = UIColor.white
    }
}
