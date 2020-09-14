//
//  MyResultController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/10/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyResultController: UIViewController {
    
    @IBOutlet var lbError: UILabel!
    @IBOutlet var historyTableView: UITableView!
    @IBOutlet var centerIndicator: UIActivityIndicatorView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var txtCategory: UITextField!
    var refreshControl = UIRefreshControl()
    var results = [Result]()
    var categories = [Category]()
    var cateid = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        lbError.isHidden = true
        customizeLayout()
        createNumberPicker()
        createToolBar()
        getCategoryArray()
        heightConstraint.constant = 0
        indicator.isHidden = true
        loadingView.backgroundColor = .clear
        retrieveDataResult()
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        historyTableView.register(nib, forCellReuseIdentifier: "HistoryCell")
        historyTableView.dataSource = self
        txtCategory.delegate = self
    }
    
    func customizeLayout(){
        txtCategory.textAlignment = .center
        txtCategory.backgroundColor = UIColor.white
        txtCategory.layer.borderColor = #colorLiteral(red: 1, green: 0.533514853, blue: 0.5298943314, alpha: 1)
    }
    
    func isErrorHidden(results: [Result]){
        if self.results.count == 0 {
            self.lbError.isHidden = false
        } else {
            self.addRefreshControl()
            self.lbError.isHidden = true
        }
    }
    
    func retrieveDataResult(){
        if results.count == 0{
            centerIndicator.isHidden = false
            centerIndicator.startAnimating()
            historyTableView.isHidden = true
            lbError.isHidden = true
        }
        
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
                myList.sorted { (first, second) in
                    first.result > second.result
                }
                self.historyTableView.reloadData()
                self.isErrorHidden(results: self.results)
                self.historyTableView.isHidden = false
                self.centerIndicator.isHidden = true
                self.centerIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }
        }
        
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
    
    func addRefreshControl(){
        self.refreshControl.tintColor = UIColor.clear
        self.refreshControl.alpha = 0
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        self.refreshControl.attributedTitle = NSAttributedString(string: "", attributes: attributes)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControl.Event.valueChanged)
        self.historyTableView.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: UIRefreshControl){
        loadResultByCategory()
        indicator.startAnimating()
        refreshControl.beginRefreshing()
        indicator.isHidden = false
        heightConstraint.constant = 60
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.heightConstraint.constant = 0
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.refreshControl.endRefreshing()
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
    
//    @objc func dismissKeyboard(){
//        view.endEditing(true)
//    }
    
    @objc func loadResultByCategory(){
        if results.count == 0{
            centerIndicator.isHidden = false
            centerIndicator.startAnimating()
            historyTableView.isHidden = true
            //lbError.isHidden = true
        }
        
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
                self.historyTableView.reloadData()
                self.isErrorHidden(results: self.results)
                self.historyTableView.isHidden = false
                self.centerIndicator.isHidden = true
                self.centerIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }
        }
        view.endEditing(true)
    }
    
}

extension MyResultController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        //let cell = HistoryCell.loadCell(historyTableView)
        cell.setUpData(with: results[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
}

extension MyResultController : UIPickerViewDelegate, UIPickerViewDataSource {
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

extension MyResultController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
