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
import AuthenticationServices
class ViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet var btnFacebook: UIButton!
    
    @IBOutlet var btnGoogle: UIButton!
    var test = [String]()
    var questions = [Question]()
    var accounts = [Account]()
    var newChild: Int = 0
    let limit = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveDataQuestion()
        customizeButton()
        getAccountList()
        print(accounts.count)
        GIDSignIn.sharedInstance()?.delegate = self
        if checkLogin() {
            goToCategory()
        }
    }
    
    func goToCategory(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "tabbar_vc") as? MyTabBarController
        //self.navigationController?.pushViewController(vc!, animated: true)
        vc?.modalTransitionStyle = .coverVertical
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    func checkLogin() -> Bool {
        if MyDatabase.user.string(forKey: keys.name) != nil {
            return true
        }
        return false
    }
    
    //set navigation bar of the first screen disappear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
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
                        let a = self.getExisingInfo(name: name, email: email, typeid: 2)
                        self.saveToDefaults(id: a.id, name: a.name, nickname: a.nickname, typeid: 2, email: email, limit: a.limit, facebookid: a.facebookid)
                    } else {
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
                                MyDatabase.ref.child("Account").child(String(thisChild)).updateChildValues(["id": self.newChild, "name": name, "mail":email,"facebookid": id, "typeid":2, "nickname": name,"timelimit": self.limit]){
                                    (error,reference) in
                                    if error == nil {
                                        print("Sign in successfully!")
                                        self.saveToDefaults(id: thisChild, name: name, nickname: name, typeid: 2, email: email, limit: self.limit, facebookid: id)
                                        print("FB sign in successfully")
                                        
                                    }
                                }
                                self.saveToDefaults(id: thisChild, name: name, nickname: name, typeid: 2, email: email, limit: self.limit, facebookid: id)
                                
                                
                            }
                        }
                    }
                    self.goToCategory()
                    
                }
            }
        }
        
        
    }
    
    @IBAction func clickBtnGoogle(_ sender: Any) {
        signInWithGoogle()
    }
    func customizeButton(){
            btnGoogle.layer.cornerRadius = 10
            btnGoogle.layer.shadowOpacity = 0.3
            btnGoogle.layer.shadowOffset = CGSize(width: 2, height: 2)
            btnGoogle.layer.shadowRadius = 10.0
            btnFacebook.layer.cornerRadius = 10
            btnFacebook.layer.shadowOpacity = 0.3
            btnFacebook.layer.shadowOffset = CGSize(width: 2, height: 2)
            btnFacebook.layer.shadowRadius = 10.0
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
                        let nickname = value["nickname"] as? String
                        let limit = value["timelimit"] as? Int
                        let account = Account(id: id!, name: name!, mail: mail!, facebookid: facebookid, typeid: typeid!, nickname: nickname!, limit: limit!)
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
    
    func getExisingInfo(name: String, email: String, typeid: Int) -> Account{
        var id0: Int = 0
        var name0: String = ""
        var email0: String = ""
        var fid0: String = ""
        var limit0: Int = 0
        var typeid0: Int = 0
        var nickname0: String = ""
        for acc in self.accounts {
            if acc.mail == email && acc.name == name && acc.typeid == typeid {
                id0 = acc.id
                name0 = acc.name
                email0 = acc.mail
                fid0 = acc.facebookid
                limit0 = acc.limit
                nickname0 = acc.nickname
                typeid0 = acc.typeid
                break
            }
        }
        let a = Account(id: id0, name: name0, mail: email0, facebookid: fid0, typeid: typeid0, nickname: nickname0, limit: limit0)
        return a
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
        if let _ = error {
            print("There is error")
            return
        }
        var thisChild: Int = 0
        let email = user.profile.email as String
        let fullName = user.profile.name as String
        print(email)
        print(fullName)
        if checkAccountExist(name: fullName, email: email, typeid: 1) != 0{
            let a = getExisingInfo(name: fullName, email: email, typeid: 1)
            saveToDefaults(id: a.id, name: a.name, nickname: a.nickname, typeid: a.typeid, email: a.mail, limit: a.limit, facebookid: a.facebookid)
        } else {
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
                    MyDatabase.ref.child("Account").child(String(thisChild)).updateChildValues(["id": thisChild, "name": fullName, "mail":email,"facebookid": "", "typeid":1,"nickname": fullName, "timelimit":self.limit]){
                        (error,reference) in
                        if error == nil {
                            print("Sign in successfully!")
                            print(thisChild)
                        }
                        
                    }
                }
            }
            saveToDefaults(id: thisChild, name: fullName, nickname: fullName, typeid: 1, email: email, limit: limit, facebookid: "")
        }
        goToCategory()
    }
    
    func saveToDefaults(id: Int, name: String, nickname: String,typeid: Int, email: String,limit: Int, facebookid: String){
        MyDatabase.user.set(name, forKey: keys.name)
        MyDatabase.user.set(id, forKey: keys.accountid)
        MyDatabase.user.set(facebookid, forKey: keys.facebookid)
        MyDatabase.user.set(email, forKey: keys.email)
        MyDatabase.user.set(nickname, forKey: keys.nickname)
        MyDatabase.user.set(limit, forKey: keys.limit)
        MyDatabase.user.set(typeid, forKey: keys.typeid)
    }
    
    func UIColorFromRGB(_ rgbValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0x00FF00) >> 8))/255.0, blue: ((CGFloat)((rgbValue & 0x0000FF)))/255.0, alpha: 1.0)
    }
    
}

