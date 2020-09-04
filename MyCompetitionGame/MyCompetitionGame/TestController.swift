//
//  TestController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class TestController: UIViewController {

    
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var lbCategory: UILabel!
    @IBOutlet var testTableView: UITableView!
    var questions = [Question]()
    var test = [Question]()
    var cateid: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelCategory()
        retrieveDataQuestionTest()
        let nib = UINib(nibName: "QuestionCell", bundle: nil)
        testTableView.register(nib, forCellReuseIdentifier: "QuestionCell")
        testTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func retrieveDataQuestionTest(){
       // var myList = [Question]()
        MyDatabase.ref.child("Question").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print(snap.key)
                    if let value = snap.value as? [String : Any] {
                        let questionid = value["questionid"] as? Int
                        let categoryid = value["categoryid"] as? Int
                        let content = value["content"] as? String
                        let trueAns = value["trueAns"] as? String
                        let falseAns1 = value["falseAns1"] as? String
                        let falseAns2 = value["falseAns2"] as? String
                        let falseAns3 = value["falseAns3"] as? String
                        let question = Question(questionid: questionid!, categoryid: categoryid!, content: content!, trueAns: trueAns!, falseAns1: falseAns1!, falseAns2: falseAns2!, falseAns3: falseAns3!)
                        if categoryid == self.cateid {
                            self.test.append(question)
                        }
                    }
                }
                print("result : \(self.test.count)")
                self.test.shuffle()
                self.testTableView.reloadData()
            }
        }
        
    }
    func setLabelCategory(){
        //var myList = [Category]()
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
                        if categoryid == self.cateid {
                            self.lbCategory.text = "C: \(name!)"
                        }
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func submitTest(_ sender: Any) {
        
    }
    
}

extension TestController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.setUp(data: test[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension TestController : QuestionCellDelegate {
    func didChooseOption(with index: Int) {
        
    }
}

