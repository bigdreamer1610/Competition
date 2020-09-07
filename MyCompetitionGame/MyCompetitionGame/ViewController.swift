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
    var accounts = [Account]()
    var newChild: Int = 0
    @IBOutlet var btnTest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveDataQuestion()
        customizeButton()
        getAccountList()
        print(accounts.count)
        GIDSignIn.sharedInstance()?.delegate = self
    }
    @IBAction func clickBtnTest(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu_vc") as? MenuViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func clickBtnFacebook(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [Permission.publicProfile], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login")
            case .success:
                print("Logged in")
                //store data to firebase
                self.storeFBtoFirebase()
                //push to menu
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Menu_vc") as? MenuViewController
                self.navigationController?.pushViewController(vc!, animated: true)
            }
        }
        
    }
    
    
    func storeFBtoFirebase() {
        var thisChild: Int = 0
        if(AccessToken.current) != nil{
            GraphRequest(graphPath: "me", parameters: ["fields":"id, email, name"]).start { (connection, result, error) in
                if(error == nil){
                    let dict = result as! [String: AnyObject]
                    print("result")
                    let value = dict as NSDictionary
                    let name = value.object(forKey: "name") as! String
                    let id = value.object(forKey: "id") as! String
                    let email = value.object(forKey: "email") as! String
                    if self.checkAccountExist(name: name, email: email, typeid: 2) != 0 {
                        print("my id exist: \(self.checkAccountExist(name: name, email: email, typeid: 2))")
                        MyDatabase.user.set(name, forKey: keys.name)
                        MyDatabase.user.set(email, forKey: keys.email)
                        MyDatabase.user.set(self.checkAccountExist(name: name, email: email, typeid: 2), forKey: keys.accountid)
                    } else {
                        print("my id does not exist: \(self.checkAccountExist(name: name, email: email, typeid: 2))")
                        MyDatabase.ref.child("Account").observeSingleEvent(of: .value) {[weak self] (snapshot) in
                            guard let `self` = self else {
                                return
                            }
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                                if snapshots.count < 1 {
                                    self.newChild = 1
                                    print("count < 1")
                                } else {
                                    print("count > 1")
                                    for snap in snapshots.reversed() {
                                        let keyString = snap.key
                                        if let keyInt = Int(keyString){
                                            self.newChild = keyInt + 1
                                        }
                                        break
                                    }
                                }
                                thisChild = self.newChild
                                MyDatabase.ref.child("Account").child(String(thisChild)).updateChildValues(["id": self.newChild, "name": name, "mail":email,"facebookid": id, "typeid":2]){
                                    (error,reference) in
                                    if error == nil {
                                        print("Sign in successfully!")
                                        MyDatabase.user.set(name, forKey: keys.name)
                                        MyDatabase.user.set(email, forKey: keys.email)
                                        MyDatabase.user.set(thisChild, forKey: keys.accountid)
                                    }
                                }
                                
                                
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func clickBtnGoogle(_ sender: Any) {
        signInWithGoogle()
    }
    func customizeButton(){
        btnFacebook.applyGradient(colors: [UIColorFromRGB(0x3b5998).cgColor,UIColorFromRGB(0x8b9dc3).cgColor])
        btnGoogle.applyGradient(colors: [UIColorFromRGB(0x3cba54).cgColor,UIColorFromRGB(0xf4c20d).cgColor,UIColorFromRGB(0xdb3236).cgColor,UIColorFromRGB(0x4885ed).cgColor])
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
    func getAccountList(){
        var myAccountList = [Account]()
        MyDatabase.ref.child("Account").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? [String : Any] {
                        let id = value["id"] as? Int
                        let name = value["name"] as? String
                        let mail = value["mail"] as? String
                        let facebookid = value["facebookid"] as? String ?? ""
                        let typeid = value["typeid"] as? Int
                        let account = Account(id: id!, name: name!, mail: mail!, facebookid: facebookid, typeid: typeid!)
                        myAccountList.append(account)
                    }
                }
                self.accounts = myAccountList
            }
        }
    }
    func checkAccountExist(name: String, email: String, typeid: Int) -> Int{
        var myId: Int = 0
        for acc in self.accounts {
            if acc.mail == email && acc.name == name && acc.typeid == typeid {
                myId = acc.id
                break
            }
        }
        return myId
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
        var thisChild: Int = 0
        print("alo alo google")
        //let userid = user.userID
        let email = user.profile.email as String
        let fullName = user.profile.name as String
        print(email)
        print(fullName)
        if checkAccountExist(name: fullName, email: email, typeid: 1) != 0{
            print("my id exist: \(checkAccountExist(name: fullName, email: email, typeid: 1))")
            MyDatabase.user.set(fullName, forKey: keys.name)
            MyDatabase.user.set(email, forKey: keys.email)
            MyDatabase.user.set(checkAccountExist(name: fullName, email: email, typeid: 1), forKey: keys.accountid)
        } else {
            print("my id does not exist: \(checkAccountExist(name: fullName, email: email, typeid: 1))")
            MyDatabase.ref.child("Account").observeSingleEvent(of: .value) {[weak self] (snapshot) in
                guard let `self` = self else {
                    return
                }
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    if snapshots.count < 1 {
                        self.newChild = 1
                        print("count < 1")
                    } else {
                        print("count > 1")
                        for snap in snapshots.reversed() {
                            let keyString = snap.key
                            if let keyInt = Int(keyString){
                                self.newChild = keyInt + 1
                            }
                            break;
                        }
                    }
                    thisChild = self.newChild
                    MyDatabase.ref.child("Account").child(String(thisChild)).updateChildValues(["id": thisChild, "name": fullName, "mail":email,"facebookid": "", "typeid":1]){
                        (error,reference) in
                        if error == nil {
                            print("Sign in successfully!")
                            MyDatabase.user.set(fullName, forKey: keys.name)
                            MyDatabase.user.set(email, forKey: keys.email)
                            MyDatabase.user.set(thisChild, forKey: keys.accountid)
                            print(thisChild)
                        }
                        
                    }
                }
            }
            MyDatabase.user.set(fullName, forKey: keys.name)
            MyDatabase.user.set(email, forKey: keys.email)
            MyDatabase.user.set(thisChild, forKey: keys.accountid)
        }
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Menu_vc") as? MenuViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF)))/255.0, alpha: 1.0)
    }
    
}
