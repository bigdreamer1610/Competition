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

class RankingController: UIViewController {

    
    
    @IBOutlet var txtCategory: UITextField!
    @IBOutlet var thirdDuration: UILabel!
    @IBOutlet var secondDuration: UILabel!
    @IBOutlet var firstDuration: UILabel!
    @IBOutlet var thirdMail: UILabel!
    @IBOutlet var secondMail: UILabel!
    @IBOutlet var firstMail: UILabel!
    @IBOutlet var thirdName: NSLayoutConstraint!
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
        
        // Do any additional setup after loading the view.
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
            }
        }
        
        
    }
    func retrieveDataResult(){
//        if results.count == 0{
//            centerIndicator.isHidden = false
//            centerIndicator.startAnimating()
//            historyTableView.isHidden = true
//            lbError.isHidden = true
//        }
        
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
                        if accountid == MyDatabase.user.integer(forKey: keys.accountid) && categoryid == 1{
                            myList.append(history)
                        }
                    }
                }
                self.results = myList
                self.results.sorted { (first, second) in
                    first.result > second.result
                }
                if self.results[0] != nil {
                    self.firstPoint.text = "\(self.results[0].result)"
                    let a = self.getExisingInfo(accountid: self.results[0].accountid)
                    self.firstName.text = "\(a.name)"
                    self.firstMail.text = "\(a.mail)"
                    self.firstDuration.text = "\(self.results[0].duration)"
                }
                
                /*
                 let sortedUsers = users.sorted {
                     $0.firstName < $1.firstName
                 }
                 */
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
//        if results.count == 0{
//            centerIndicator.isHidden = false
//            centerIndicator.startAnimating()
//            historyTableView.isHidden = true
//            //lbError.isHidden = true
//        }
        
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
                        if accountid == MyDatabase.user.integer(forKey: keys.accountid) && categoryid == self.cateid  {
                            myList.append(history)
                        }
                    }
                }
                self.results = myList
                self.results.sorted { (first, second) in
                    first.result > second.result
                }
                if self.results[0] != nil {
                    self.firstPoint.text = "\(self.results[0].result)"
                    let a = self.getExisingInfo(accountid: self.results[0].accountid)
                    self.firstName.text = "\(a.name)"
                    self.firstMail.text = "\(a.mail)"
                    self.firstDuration.text = "\(self.results[0].duration)"
                }
            }
        }
        view.endEditing(true)
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

extension RankingController : UIPickerViewDelegate, UIPickerViewDataSource {
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

extension RankingController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
