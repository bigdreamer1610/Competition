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
    
    
    @IBOutlet var lbTime: UILabel!
    //@IBOutlet var lbTime: UILabel!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var lbCategory: UILabel!
    @IBOutlet var testTableView: UITableView!
    var test = [Question]()
    var myTest = [Question]()
    var countNoOfQuestions = 0
    var cateid: Int = 0
    var playerArray = [Int](repeating: 0, count: 10)
    var systemArray = [Int]()
    var result: Int = 0
    var newChild: String = ""
    var count = 600
    var timer:Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        setLabelCategory()
        
        getNewChildTitle()
        let nib = UINib(nibName: "QuestionCell", bundle: nil)
        testTableView.register(nib, forCellReuseIdentifier: "QuestionCell")
        testTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        lbTime.text = "600"
        for _ in 1...10 {
            systemArray.append(Int.random(in: 1...4))
        }
        retrieveDataQuestionTest()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        count -= 1
        lbTime.text = String(count)
        if(count < 1){
            timer?.invalidate()
            finishQuiz()
        }
    }
    
    func finishQuiz(){
        for i in 0..<systemArray.count {
            if systemArray[i] == playerArray[i]{
                result += 1;
            }
        }
        
        //push vc result
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Result_vc") as? ResultController
        vc?.myScore = result
        vc?.totalScore = systemArray.count
        print("new value: \(newChild)")
        //date
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        //print(dateFormatter.string(from: date))
        let dateString = dateFormatter.string(from: date)
        //add new object to firebase
        let newResult: [String : Any] = [
            "resultid" : Int(newChild)! as NSObject,
            "accountid" : MyDatabase.user.integer(forKey: keys.accountid),
            "result" : result,
            "duration" : 600 - count,
            "time" : dateString,
            "categoryid" : cateid
        ]
        MyDatabase.ref.child("Result").child(newChild).setValue(newResult)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func submitTest(_ sender: Any) {
        finishQuiz()
        
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
                            print(question.options)
                        }
                    }
                }
                print("result : \(self.test.count)")
                self.test.shuffle()
                for i in 0..<10 {
                    self.myTest.append(self.test[i])
                }
                self.testTableView.reloadData()
            }
        }
        
    }
    func setLabelCategory(){
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
    
    
    
    
    //get new child name
    func getNewChildTitle(){
        MyDatabase.ref.child("Result").observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let `self` = self else {
                return
            }
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots.reversed() {
                    let keyString = snap.key
                    if let keyInt = Int(keyString){
                        self.newChild = String(keyInt + 1)
                    }
                    break;
                }
            }
        }
        
    }
    
}

extension TestController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.setUp(data: myTest[indexPath.row], index: indexPath.row)
        cell.index = indexPath.row
        cell.trueAnsIndex = systemArray[indexPath.row]
        cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        //var value = playerArray[indexPath.row]
        let value = playerArray[indexPath.row]
        if value != 0 {
            switch value {
            case 1:
                cell.setButtonState(stateA: true, stateB: false, stateC: false, stateD: false)
            case 2:
                cell.setButtonState(stateA: false, stateB: true, stateC: false, stateD: false)
            case 3:
                cell.setButtonState(stateA: false, stateB: false, stateC: true, stateD: false)
            default:
                cell.setButtonState(stateA: false, stateB: false, stateC: true, stateD: true)
            }
        }
        return cell
    }
    
}

extension TestController : QuestionCellDelegate {
    func didChooseOption(with option: Int, with index: Int) {
        print("Question: \(index + 1): option (\(option))")
        playerArray[index] = option
        print(playerArray)
        print(systemArray)
        
    }
}

