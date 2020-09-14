//
//  ResultController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/4/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ResultController: UIViewController {

    
    
    @IBOutlet var lbNickName: UILabel!
    @IBOutlet var lbTotal: UILabel!
    @IBOutlet var btnBackMenu: UIButton!
    @IBOutlet var lbScore: UILabel!
    var myScore: Int = 0
    var totalScore: Int = 0
    var cateid: Int = 0
    var categories = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        getCategoryName()
        lbScore.text = "\(myScore)"
        lbTotal.text = "out of \(totalScore)"
        customizeLayout()
        lbNickName.text = MyDatabase.user.string(forKey: keys.nickname)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
           navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func customizeLayout(){
        btnBackMenu.layer.cornerRadius = 20
        btnBackMenu.layer.borderWidth = 2
        btnBackMenu.layer.borderColor = UIColor.black.cgColor
        btnBackMenu.backgroundColor = .clear
        btnBackMenu.layer.masksToBounds = true
        
        
        //gradient
        //btnBackMenu.applyGradient(colors: [UIColorFromRGB(0x2B95CE).cgColor,UIColorFromRGB(0x2ECAD5).cgColor])
        
        lbScore.layer.cornerRadius = 10
        lbScore.backgroundColor = .clear
        lbScore.layer.borderColor = UIColor.green.cgColor
    }
    
    
    
    @IBAction func clickBack(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar_vc") as? MyTabBarController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
     func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF)))/255.0, alpha: 1.0)
    }
    
    func getCategoryName(){
        var myList = [Category]()
        MyDatabase.ref.child("Category").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print(snap.key)
                    if let value = snap.value as? [String : Any] {
                        let categoryid = value["categoryid"] as? Int
                        let name = value["name"] as? String
                        let category = Category(categoryid: categoryid!, name: name!)
                        myList.append(category)
                    }
                }
                self.categories = myList
                var cateName = ""
                for c in self.categories {
                    if c.categoryid == self.cateid{
                        cateName = c.name
                    }
                }
            }
        }
        
        
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
