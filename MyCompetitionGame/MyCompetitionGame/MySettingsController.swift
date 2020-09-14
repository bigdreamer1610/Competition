//
//  MySettingsController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/10/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn
import FBSDKLoginKit

class MySettingsController: UIViewController {

    
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet var btnUpdate: UIButton!
    @IBOutlet var txtLimit: UITextField!
    @IBOutlet var txtNickname: UITextField!
    @IBOutlet var lbEmail: UILabel!
    @IBOutlet var lbName: UILabel!
    var name: String = MyDatabase.user.string(forKey: keys.name) ?? ""
    var nickname: String = MyDatabase.user.string(forKey: keys.nickname) ?? ""
    var limit:Int = MyDatabase.user.integer(forKey: keys.limit)
    var email:String = MyDatabase.user.string(forKey: keys.email) ?? ""
    var facebookid:String = MyDatabase.user.string(forKey: keys.facebookid) ?? ""
    var typeid:Int = MyDatabase.user.integer(forKey: keys.typeid)
    var id:Int = MyDatabase.user.integer(forKey: keys.accountid)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        customizeLayout()
        setUpSettingsInfo()
        txtLimit.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func setUpSettingsInfo(){
        lbEmail.text = email
        txtNickname.text = nickname
        txtLimit.text = String(limit)
        lbName.text = name
    }
    
    func customizeLayout(){
        //logout
        btnLogout.backgroundColor = UIColor.white
        btnLogout.layer.borderWidth = 0.5
        btnLogout.layer.cornerRadius = 6
        btnLogout.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btnLogout.setTitleColor(UIColor.black, for: .normal)
        
        //update
        btnUpdate.layer.cornerRadius = 6
        //textfield
    }
    

    @IBAction func clickLogout(_ sender: Any) {
        MyDatabase.user.removeObject(forKey: keys.name)
        MyDatabase.user.removeObject(forKey: keys.email)
        MyDatabase.user.removeObject(forKey: keys.accountid)
        MyDatabase.user.removeObject(forKey: keys.typeid)
        MyDatabase.user.removeObject(forKey: keys.facebookid)
        MyDatabase.user.removeObject(forKey: keys.nickname)
        MyDatabase.user.removeObject(forKey: keys.limit)
        GIDSignIn.sharedInstance()?.signOut()
        let loginManager = LoginManager()
        loginManager.logOut() // this is an instance function
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "View_vc") as? ViewController
        vc?.modalTransitionStyle = .flipHorizontal
        vc?.modalPresentationStyle = .fullScreen
        present(vc!, animated: true, completion: nil)
    }
    @IBAction func clickUpdate(_ sender: Any) {
        nickname = txtNickname.text!
        if let myLimit = Int(txtLimit.text!){
            limit = myLimit
        }
        //store user default
        MyDatabase.user.set(nickname, forKey: keys.nickname)
        MyDatabase.user.set(limit, forKey: keys.limit)
        //firebase update
        MyDatabase.ref.child("Account").child(String(id)).updateChildValues(["id": id, "name": name , "mail":email,"facebookid": facebookid, "typeid":typeid,"nickname": nickname, "timelimit":limit]){
            (error,reference) in
            if error == nil {
                let alert = UIAlertController(title: "Update Settings", message: "Update Successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
}

//restrict input only number
extension MySettingsController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //only text num
        let allowCharacters = "0123456789"
        let allowCharacterSet = CharacterSet(charactersIn: allowCharacters)
        let typeCharacterSet = CharacterSet(charactersIn: string)
        return allowCharacterSet.isSuperset(of: typeCharacterSet)
        //return false
    }
}
