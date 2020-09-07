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

    var results = [Result]()
    @IBOutlet var historyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        retrieveDataResult()
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        historyTableView.register(nib, forCellReuseIdentifier: "HistoryCell")
        historyTableView.delegate = self
        historyTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    func retrieveDataResult(){
       // var myList = [Question]()
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
                        if accountid == 1 {
                            self.results.append(history)
                        }
                    }
                }
                print(self.results.count)
                self.historyTableView.reloadData()
            }
        }
        
    }
}

extension HistoryController : UITableViewDelegate {
    
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
