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
class ViewController: UIViewController {
    
    //private let ref = Database.database().reference()
    
    var test = [String]()
    var questions = [Question]()
    @IBOutlet var btnAdd: UIButton!
    
    
    @IBOutlet var btnTest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveDataQuestion()
        print(questions.count)
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
                        self.questions.append(question)
                    }
                }
                print(self.questions.count)
            }
        }
        
    }
    
    
    @IBAction func clickBtnTest(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Menu_vc") as? MenuViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
    
}

