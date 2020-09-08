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
import GoogleSignIn

class MenuViewController: UIViewController {

    @IBOutlet var btnViewCate: UIButton!
    
    @IBOutlet var lbHello: UILabel!
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnViewResult: UIButton!
    var name: String = "aaa"
    //@IBOutlet var btnTakeTest: UIButton!
    var categories = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(MyDatabase.user.string(forKey: keys.name)!)
        customizeButton()
        if MyDatabase.user.string(forKey: keys.name) == nil {
            MyDatabase.user.set(name, forKey: keys.name)
        } else {
            name = MyDatabase.user.string(forKey: keys.name)!
        }
        lbHello.text = "Hello, \(name)"

        self.navigationItem.hidesBackButton = true
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
    
    func customizeButton(){
        btnViewCate.layer.cornerRadius = 15
        btnViewCate.layer.borderWidth = 1
        btnViewCate.layer.borderColor = UIColor.black.cgColor

        btnViewResult.layer.cornerRadius = 15
        btnViewResult.layer.borderWidth = 1
        btnViewResult.layer.borderColor = UIColor.black.cgColor
    }
    
    

    @IBAction func clickViewAllCate(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Category_vc") as? CategoryController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func clickLogout(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        let loginManager = LoginManager()
        loginManager.logOut() // this is an instance function
        MyDatabase.user.removeObject(forKey: keys.name)
        MyDatabase.user.removeObject(forKey: keys.email)
        MyDatabase.user.removeObject(forKey: keys.accountid)
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "View_vc") as? ViewController
        vc?.modalTransitionStyle = .flipHorizontal
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
    
    
    @IBAction func clickViewResult(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "History_vc") as? HistoryController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF)))/255.0, alpha: 1.0)
    }
}
