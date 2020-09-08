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


    
    @IBOutlet var centerIndicator: UIActivityIndicatorView!
    @IBOutlet var heightConstant: NSLayoutConstraint!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var indicatorView: UIView!
    @IBOutlet var questionTableView: UITableView!
    var refreshControl = UIRefreshControl()
    var questions = [Question]()
    var questionsByCate = [Question]()
    var cateid: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        heightConstant.constant = 0
        centerIndicator.isHidden = true
        indicator.isHidden = true
        indicatorView.backgroundColor = .clear
        retrieveDataQuestion()
        fetchQuestionsByCateid(cateid: cateid)
        let nib = UINib(nibName: "SingleQuestionCell", bundle: nil)
        questionTableView.register(nib, forCellReuseIdentifier: "SingleQuestionCell")
        questionTableView.dataSource = self
    }
    
    func retrieveDataQuestion(){
        if questions.count == 0 {
            centerIndicator.startAnimating()
            centerIndicator.isHidden = false
            questionTableView.isHidden = true
        }
        var myQuestions = [Question]()
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
                            myQuestions.append(question)
                        }
                        
                    }
                }
                self.questions = myQuestions
                self.addRefreshControl()
                self.questionTableView.reloadData()
                self.questionTableView.isHidden = false
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
        self.questionTableView.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: UIRefreshControl){
        retrieveDataQuestion()
        //categoryTableView.reloadData()
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
