//
//  HistoryController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/7/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class HistoryController: UIViewController {

    
    
    @IBOutlet var centerIndicator: UIActivityIndicatorView!
    @IBOutlet var heightConstant: NSLayoutConstraint!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var indicatorView: UIView!
    @IBOutlet var lbError: UILabel!
    var results = [Result]()
    @IBOutlet var historyTableView: UITableView!
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        heightConstant.constant = 0
        indicator.isHidden = true
        indicatorView.backgroundColor = .clear
        retrieveDataResult()
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        historyTableView.register(nib, forCellReuseIdentifier: "HistoryCell")
        historyTableView.dataSource = self
        // Do any additional setup after loading the view.
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
                        if accountid == MyDatabase.user.integer(forKey: keys.accountid) {
                            myList.append(history)
                        }
                    }
                }
                self.results = myList
                if self.results.count == 0 {
                    self.lbError.isHidden = false
                } else {
                    self.addRefreshControl()
                    self.lbError.isHidden = true
                }
                self.historyTableView.reloadData()
                self.historyTableView.isHidden = false
                self.centerIndicator.isHidden = true
                self.centerIndicator.stopAnimating()
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
        retrieveDataResult()
        indicator.startAnimating()
        refreshControl.beginRefreshing()
        indicator.isHidden = false
        heightConstant.constant = 60
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.heightConstant.constant = 0
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.refreshControl.endRefreshing()
        }
    }
}


extension HistoryController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.setUpData(with: results[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
}
