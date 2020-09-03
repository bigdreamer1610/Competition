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

class MenuViewController: UIViewController {

    @IBOutlet var btnViewCate: UIButton!
    
    @IBOutlet var lbHello: UILabel!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnViewResult: UIButton!
    @IBOutlet var btnTakeTest: UIButton!
    var categories = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clickViewAllCate(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Category_vc") as? CategoryController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func clickTakeTest(_ sender: Any) {
    }
    
    @IBAction func clickViewResult(_ sender: Any) {
    }
}
