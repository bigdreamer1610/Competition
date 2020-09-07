//
//  MenuViewController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit

class MenuViewController: UIViewController {

    @IBOutlet var btnViewCate: UIButton!
    
    @IBOutlet var lbHello: UILabel!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnViewResult: UIButton!
    //@IBOutlet var btnTakeTest: UIButton!
    var categories = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeButton()

        // Do any additional setup after loading the view.
    }
    
    func customizeButton(){
        btnViewCate.backgroundColor = .clear
        btnViewCate.layer.cornerRadius = 15
        btnViewCate.layer.borderWidth = 1
        btnViewCate.layer.borderColor = UIColor.black.cgColor
        
        btnViewResult.backgroundColor = .clear
        btnViewResult.layer.cornerRadius = 15
        btnViewResult.layer.borderWidth = 1
        btnViewResult.layer.borderColor = UIColor.black.cgColor
    }
    
    
    
    @IBAction func clickHistory(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "History_vc") as? HistoryController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func clickViewAllCate(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Category_vc") as? CategoryController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func clickLogout(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logOut() // this is an instance function
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "View_vc") as? ViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func clickTakeTest(_ sender: Any) {
    }
    
    @IBAction func clickViewResult(_ sender: Any) {
    }
}
