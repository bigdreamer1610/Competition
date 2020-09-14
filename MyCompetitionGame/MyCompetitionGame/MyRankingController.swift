//
//  RankingController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/10/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyRankingController: UIViewController {
    
    

    @IBOutlet var thirdName: UILabel!
    @IBOutlet var txtCategory: UITextField!
    @IBOutlet var thirdDuration: UILabel!
    @IBOutlet var secondDuration: UILabel!
    @IBOutlet var firstDuration: UILabel!
    @IBOutlet var thirdMail: UILabel!
    @IBOutlet var secondMail: UILabel!
    @IBOutlet var firstMail: UILabel!
    @IBOutlet var secondName: UILabel!
    @IBOutlet var firstName: UILabel!
    @IBOutlet var firstPoint: UILabel!
    @IBOutlet var thirdPoint: UILabel!
    @IBOutlet var secondPoint: UILabel!
    var results = [Result]()
    var cateid = 1
    var categories = [Category]()
    var accounts = [Account]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAccountList()
        getCategoryArray()
        retrieveDataResult()
        createToolBar()
        createToolBar()
        //customizeLayout(views: [medalView,silverView,bronzeView])
        txtCategory.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func customizeLayout(){
//        for view in views {
//            view.layer.shadowRadius = 5
//            view.layer.cornerRadius = 6
//            view.layer.shadowOpacity = 0.5
//            view.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
//        }
        
    }
    
    func getCategoryArray(){
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
                self.txtCategory.text = self.categories[0].name
                print("Category count: \(self.categories.count)")
            }
        }
        
        
    }
    func retrieveDataResult(){
        var myList = [Result]()
        MyDatabase.ref.child("Result").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print(snap.key)
                    if let value = snap.value as? [String : Any] {
                        let resultid = value["resultid"] as? Int
                        let accountid = value["accountid"] as? Int
                        let result = value["result"] as? Int
                        let duration = value["duration"] as? Int
                        let time = value["time"] as? String
                        let categoryid = value["categoryid"] as? Int
                        let history = Result(resultid: resultid!, accountid: accountid!, categoryid: categoryid!, result: result!, duration: duration!, time: time!)
                        if categoryid == 1{
                            myList.append(history)
                        }
                    }
                }
                self.results = myList
                self.results.sorted { (first, second) in
                    first.result > second.result
                }
                //set up rank
                self.setUpRank(result: self.results[0], lbPoint: self.firstPoint, lbName: self.firstName, lbEmail: self.firstMail, lbDuration: self.firstDuration)
                self.setUpRank(result: self.results[1], lbPoint: self.secondPoint, lbName: self.secondName, lbEmail: self.secondMail, lbDuration: self.secondDuration)
                self.setUpRank(result: self.results[2], lbPoint: self.thirdPoint, lbName: self.thirdName, lbEmail: self.thirdMail, lbDuration: self.thirdDuration)
                
            }
        }
        
    }
    func createNumberPicker(){
        let numberPicker = UIPickerView()
        numberPicker.delegate = self
        txtCategory.inputView = numberPicker
    }
    
    func createToolBar(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(loadResultByCategory))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        txtCategory.inputAccessoryView = toolbar
    }
    
    @objc func loadResultByCategory(){
        var myList = [Result]()
        MyDatabase.ref.child("Result").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print(snap.key)
                    if let value = snap.value as? [String : Any] {
                        let resultid = value["resultid"] as? Int
                        let accountid = value["accountid"] as? Int
                        let result = value["result"] as? Int
                        let duration = value["duration"] as? Int
                        let time = value["time"] as? String
                        let categoryid = value["categoryid"] as? Int
                        let history = Result(resultid: resultid!, accountid: accountid!, categoryid: categoryid!, result: result!, duration: duration!, time: time!)
                        if categoryid == self.cateid  {
                            myList.append(history)
                        }
                    }
                }
                self.results = myList
                self.results.sorted { (first, second) in
                    first.result > second.result
                }
                self.setUpRank(result: self.results[0], lbPoint: self.firstPoint, lbName: self.firstName, lbEmail: self.firstMail, lbDuration: self.firstDuration)
                self.setUpRank(result: self.results[1], lbPoint: self.secondPoint, lbName: self.secondName, lbEmail: self.secondMail, lbDuration: self.secondDuration)
                self.setUpRank(result: self.results[2], lbPoint: self.thirdPoint, lbName: self.thirdName, lbEmail: self.thirdMail, lbDuration: self.thirdDuration)
            }
        }
        view.endEditing(true)
    }
    
    func setUpRank(result: Result, lbPoint: UILabel, lbName: UILabel, lbEmail: UILabel, lbDuration: UILabel){
        lbPoint.text = "\(result.result)"
        let a = getExisingInfo(accountid: result.accountid)
        lbName.text = "\(a.name)"
        lbEmail.text = "\(a.mail)"
        lbDuration.text = "\(result.duration)"
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
    
    func getExisingInfo(accountid: Int) -> Account{
        var id0: Int = 0
        var name0: String = ""
        var email0: String = ""
        var fid0: String = ""
        var limit0: Int = 0
        var typeid0: Int = 0
        var nickname0: String = ""
        for acc in self.accounts {
            if acc.id == accountid {
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
    
    
    
    
}

extension MyRankingController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtCategory.text = categories[row].name
        cateid = row + 1
        
    }
}

extension MyRankingController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
