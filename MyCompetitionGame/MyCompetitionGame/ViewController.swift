//
//  ViewController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/1/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase
import GoogleSignIn
import FBSDKLoginKit
class ViewController: UIViewController, GIDSignInDelegate {

    @IBOutlet var btnFacebook: UIButton!
    
    @IBOutlet var btnGoogle: UIButton!
    var test = [String]()
    var questions = [Question]()
    var newChild: Int = 0
    @IBOutlet var btnTest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveDataQuestion()
        customizeButton()
    }
    
    func customizeButton(){
        btnFacebook.backgroundColor = .clear
        
        btnFacebook.layer.cornerRadius = 20
        btnFacebook.layer.borderWidth = 1
        btnFacebook.layer.borderColor = UIColor.white.cgColor
        
        btnGoogle.backgroundColor = .clear
        btnGoogle.layer.cornerRadius = 20
        btnGoogle.layer.borderWidth = 1
        btnGoogle.layer.borderColor = UIColor.white.cgColor
    }
    
    func signInWithGoogle(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func retrieveDataQuestion(){
        MyDatabase.ref.child("Question").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? [String : Any] {
                        let questionid = value["questionid"] as? Int
                        let categoryid = value["categoryid"] as? Int
                        let content = value["content"] as? String
                        let trueAns = value["trueAns"] as? String
                        let falseAns1 = value["falseAns1"] as? String
                        let falseAns2 = value["falseAns2"] as? String
                        let falseAns3 = value["falseAns3"] as? String
                        let question = Question(questionid: questionid!, categoryid: categoryid!, content: content!, trueAns: trueAns!, falseAns1: falseAns1!, falseAns2: falseAns2!, falseAns3: falseAns3!)
                        self.questions.append(question)
                    }
                }
                print(self.questions.count)
            }
        }
        
    }
    
    //google
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("alo alo google")
        //let userid = user.userID
        let email = user.profile.email
        let fullName = user.profile.name
        
        MyDatabase.ref.child("Account").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                if snapshots.count < 1 {
                    self.newChild = 1
                } else {
                    for snap in snapshots.reversed() {
                        let keyString = snap.key
                        if let keyInt = Int(keyString){
                            self.newChild = keyInt + 1
                        }
                        break;
                    }
                }
                
            }
        }
        
        MyDatabase.ref.child("Account").child(String(newChild)).updateChildValues(["id": newChild, "name": fullName!, "mail":email!,"facebookid": "", "typeid":1]){
            (error,reference) in
            if error == nil {
                print("Sign in successfully!")
            }
            
        }
        
    }
    
    @IBAction func clickBtnTest(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu_vc") as? MenuViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func clickBtnGoogle(_ sender: Any) {
        signInWithGoogle()
    }
    
    func saveInfoFacebook(){
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name"]).start { (connection, result, error) in
                if error == nil {
                    let dict = result as! [String: AnyObject]
                    let value = dict as NSDictionary
                    let name = value.object(forKey: "name") as! String
                    let id = value.object(forKey: "id") as! String
                    let email = value.object(forKey: "email") as! String
                    print("name: \(name)")
                    print(id)
                    
                    MyDatabase.ref.child("Account").observeSingleEvent(of: .value) {[weak self] (snapshot) in
                        guard let `self` = self else {
                            return
                        }
                        if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                            if snapshots.count < 1 {
                                self.newChild = 1
                            } else {
                                for snap in snapshots.reversed() {
                                    let keyString = snap.key
                                    if let keyInt = Int(keyString){
                                        self.newChild = keyInt + 1
                                    }
                                    break;
                                }
                            }
                        }
                    }
                    //add into database
                    MyDatabase.ref.child("Account").child(String(self.newChild)).updateChildValues(["id": self.newChild + 1, "name": name, "mail":email,"facebookid": id, "typeid":2]){
                        (error,reference) in
                        if error != nil {
                            print("Something wrong")
                        }
                        print("Sign in successfully!")
                    }
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu_vc") as? MenuViewController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                }
            }
        }
    }
}

