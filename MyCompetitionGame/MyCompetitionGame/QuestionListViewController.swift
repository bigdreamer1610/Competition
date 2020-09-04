//
//  QuestionListViewController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class QuestionListViewController: UIViewController {


    @IBOutlet var questionTableView: UITableView!
    var questions = [Question]()
    var questionsByCate = [Question]()
    var cateid: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveDataQuestion()
        fetchQuestionsByCateid(cateid: cateid)
        print("call: \(questions.count)")
        print("by cate: \(questionsByCate.count)")
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "SingleQuestionCell", bundle: nil)
        questionTableView.register(nib, forCellReuseIdentifier: "SingleQuestionCell")
        questionTableView.dataSource = self
    }
    
    func retrieveDataQuestion(){
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
                        if question.categoryid == self.cateid {
                            self.questions.append(question)
                        }
                        
                    }
                }
                print(self.questions.count)
                self.questionTableView.reloadData()
            }
        }
        
    }
    
    func fetchQuestionsByCateid(cateid: Int){
        for ques in questions {
            if ques.categoryid == cateid {
                questionsByCate.append(ques)
            }
        }
    }
    
}


extension QuestionListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleQuestionCell", for: indexPath) as! SingleQuestionCell
        cell.setUpQuestion(data: questions[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
}
