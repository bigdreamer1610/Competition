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
    
    func retrieveDataCategory(){
        MyDatabase.ref.child("Category").observeSingleEvent(of: .value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print(snap.key)
                    let myKey = snap.key
                    MyDatabase.ref.child("Category").child(myKey).observeSingleEvent(of: .value) { (mySnap) in
                        let value = snap.value as? NSDictionary
                        let categoryid = value?["categoryid"] as? Int
                        let name = value?["name"] as? String
                        let category = Category(categoryid: categoryid!, name: name!)
                        self.categories.append(category)
                        
                    }
                }
            }
            
        }
        
    }
    
    @IBAction func clickViewAllCate(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Category_vc") as? CategoryController
        vc?.categories = categories
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func clickTakeTest(_ sender: Any) {
    }
    
    @IBAction func clickViewResult(_ sender: Any) {
    }
}
