//
//  MyTestController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/9/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyTestController: UIViewController {
    
    
    @IBOutlet var btnNext: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var optionD: UIButton!
    @IBOutlet var optionC: UIButton!
    @IBOutlet var optionB: UIButton!
    @IBOutlet var optionA: UIButton!
    @IBOutlet var lbQuestion: UILabel!
    @IBOutlet var lbCategory: UILabel!
    @IBOutlet var lbTime: UILabel!
    //@IBOutlet var numberCollectionView: UICollectionView!
    var model = ButtonModel()
    //var buttonArray = [NumberButton]()
    var questions = [Question]()
    var myTest = [Question]()
    var currentQuestion = 1
    var systemArray = [Int]()
    var playerArray = [Int](repeating: 0, count: 10)
    var count = MyDatabase.user.integer(forKey: keys.limit)
    var timer:Timer!
    var options = [String]()
    var testModel = [QuestionModel]()
    var currentQuestionIndex = 0
    let colorNotSelect = UIColor.groupTableViewBackground
    let colorSelect = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    var result = 0
    var newChild: String = ""
    var cateid: Int = 0
    var cateName: String = ""
    var buttonArray = [UIButton]()
    var currentButton: UIButton!
    var nextButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //retrieveDataQuestionTest()
        getCategoryName()
        customizeLayout()
        getNewChildTitle()
        currentButton = btn1
        //buttonArray = model.getButtons(number: 10)
        setUpNumberButton(buttons: [btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,btn10])
        buttonArray = [btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,btn10]
    }
    
    func customizeLayout(){
        btnStop.layer.cornerRadius = 6
        btnSubmit.layer.cornerRadius = 6
        btnNext.backgroundColor = .clear
        btnNext.setTitleColor(UIColor.black, for: .normal) 
        btnNext.layer.shadowRadius = 5
        btnNext.layer.cornerRadius = 10
        btnNext.layer.shadowOpacity = 0.5
        btnNext.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
    }
    
    func getCategoryName(){
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
                            self.cateName = name!
                            break
                        }
                        
                    }
                }
                self.lbCategory.text = self.cateName
            }
        }
        
        
    }
    
    func setUpNumberButton(buttons: [UIButton]){
        for button in buttons {
            button.layer.borderWidth = 1
            button.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.4880925302, blue: 0.6846527351, alpha: 1)
            button.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.4880925302, blue: 0.6846527351, alpha: 1), for: .normal)
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = 6
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        lbTime.text = "\(count)"
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
    
    func retrieveDataQuestionTest(){
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
                            self.questions.append(question)
                            
                        }
                    }
                }
                self.questions.shuffle()
                //get list 10 questions
                for i in 0..<10 {
                    self.myTest.append(self.questions[i])
                }
                //get list 10 questions model
                for j in 0..<10 {
                    let qModel = QuestionModel()
                    qModel.question = self.myTest[j]
                    var falseOptions = [String]()
                    falseOptions.append(self.myTest[j].falseAns1!)
                    falseOptions.append(self.myTest[j].falseAns2!)
                    falseOptions.append(self.myTest[j].falseAns3!)
                    qModel.falseOptions = falseOptions
                    for _ in 1...4 {
                        qModel.optionIndex.append(Int.random(in: 1...4))
                    }
                    self.systemArray.append(qModel.optionIndex[0])
                    qModel.trueOption = self.myTest[j].trueAns!
                    self.testModel.append(qModel)
                    
                }
                print("mytest: \(self.myTest.count)")
                self.setUpQuestionModel(with: self.testModel[0], index: 0)
                self.currentButton = self.btn1
                self.setButtonSelectedState(button: self.currentButton)
                print("System array: \(self.systemArray) ")
                
                
            }
        }
        
    }
    
    func setUpQuestionModel(with model: QuestionModel, index: Int){
        let q = model
        lbQuestion.text = "Question \(index + 1): \(q.question!.content)"
        switch q.optionIndex[0] {
        case 1:
            optionA.setTitle("\(q.trueOption)", for: .normal)
            setFalseValue2(lb1: optionB, lb2: optionC, lb3: optionD, ops: q.falseOptions)
        case 2:
            optionB.setTitle("\(q.trueOption)", for: .normal)
            setFalseValue2(lb1: optionA, lb2: optionC, lb3: optionD, ops: q.falseOptions)
        case 3:
            optionC.setTitle("\(q.trueOption)", for: .normal)
            setFalseValue2(lb1: optionB, lb2: optionA, lb3: optionD, ops: q.falseOptions)
        default:
            optionD.setTitle("\(q.trueOption)", for: .normal)
            setFalseValue2(lb1: optionB, lb2: optionC, lb3: optionA, ops: q.falseOptions)
        }
        let buttonStates = model.buttonStates
        var currentSelectedOption = 4
        for j in 0..<buttonStates.count{
            if buttonStates[j] {
                currentSelectedOption = j
                break
            }
        }
        switch currentSelectedOption {
        case 0:
            setUpButtonState(selected: optionA, unselected1: optionB, unselected2: optionC, unselected3: optionD)
        case 1:
            setUpButtonState(selected: optionB, unselected1: optionA, unselected2: optionC, unselected3: optionD)
        case 2:
            setUpButtonState(selected: optionC, unselected1: optionB, unselected2: optionA, unselected3: optionD)
        case 3:
            setUpButtonState(selected: optionD, unselected1: optionB, unselected2: optionC, unselected3: optionA)
        default:
            optionA.backgroundColor = colorNotSelect
            optionB.backgroundColor = colorNotSelect
            optionC.backgroundColor = colorNotSelect
            optionD.backgroundColor = colorNotSelect
            optionA.setTitleColor(colorSelect, for: .normal)
            optionB.setTitleColor(colorSelect, for: .normal)
            optionC.setTitleColor(colorSelect, for: .normal)
            optionD.setTitleColor(colorSelect, for: .normal)
            
        }
    }
    
    
    @IBAction func clickNext(_ sender: Any) {
        var index0 = -1
        for i in 0..<buttonArray.count-1 {
            if buttonArray[i] == currentButton {
                nextButton = buttonArray[i+1]
                index0 = i+1
                break
            }
        }
        if index0 != -1 {
            displayQuestionByNumber(index: index0, button: nextButton)
        } else {
            displayQuestionByNumber(index: 0, button: btn1)
        }
        
    }
    @IBAction func clickSubmit(_ sender: Any) {
        finishQuiz()
    }
    
    
    @IBAction func clickStop(_ sender: Any) {
        self.timer.invalidate()
        let alert = UIAlertController(title: "Stop the test", message: "Do you really want to stop?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { (_) in
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar_vc") as? MyTabBarController
            self.navigationController?.pushViewController(vc!, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setUpSelectedButton(button: UIButton){
        //button.layer.borderWidth = 1
        button.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0.4880925302, blue: 0.6846527351, alpha: 1)
    }
    @IBAction func chooseOption(_ sender: UIButton) {
        //set up has answer butotn
        if !testModel[currentQuestionIndex].hasAnswer {
            testModel[currentQuestionIndex].hasAnswer = true
            setUpSelectedButton(button: buttonArray[currentQuestionIndex])
//            switch currentQuestionIndex+1 {
//            case 1:
//                setUpSelectedButton(button: btn1)
//            case 2:
//                setUpSelectedButton(button: btn2)
//            case 3:
//                setUpSelectedButton(button: btn3)
//            case 4:
//                setUpSelectedButton(button: btn4)
//            case 5:
//                setUpSelectedButton(button: btn5)
//            case 6:
//                setUpSelectedButton(button: btn6)
//            case 7:
//                setUpSelectedButton(button: btn7)
//            case 8:
//                setUpSelectedButton(button: btn8)
//            case 9:
//                setUpSelectedButton(button: btn9)
//            default:
//                setUpSelectedButton(button: btn10)
//            }
        }
        
        //store option
        switch sender {
        case optionA:
            playerArray[currentQuestionIndex] = 1
            print(playerArray)
            testModel[currentQuestionIndex].buttonStates = [true,false,false,false]
            setUpButtonState(selected: optionA, unselected1: optionB, unselected2: optionC, unselected3: optionD)
        case optionB:
            
            playerArray[currentQuestionIndex] = 2
            print(playerArray)
            testModel[currentQuestionIndex].buttonStates = [false,true,false,false]
            setUpButtonState(selected: optionB, unselected1: optionA, unselected2: optionC, unselected3: optionD)
        case optionC:
            print(playerArray)
            playerArray[currentQuestionIndex] = 3
            print(playerArray)
            testModel[currentQuestionIndex].buttonStates = [false,false,true,false]
            setUpButtonState(selected: optionC, unselected1: optionB, unselected2: optionA, unselected3: optionD)
        default:
            print(playerArray)
            playerArray[currentQuestionIndex] = 4
            print(playerArray)
            testModel[currentQuestionIndex].buttonStates = [false,false,false,true]
            setUpButtonState(selected: optionD, unselected1: optionB, unselected2: optionC, unselected3: optionA)
            
        }
    }
    
    func setButtonSelectedState(button: UIButton){
        for b in buttonArray {
            if b == currentButton {
                b.layer.borderWidth = 1
                b.layer.borderColor = UIColor.black.cgColor
            } else {
                b.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.4880925302, blue: 0.6846527351, alpha: 1)
            }
        }
    }
    
    func setUpButtonState(selected: UIButton, unselected1: UIButton, unselected2: UIButton, unselected3: UIButton){
        selected.backgroundColor = colorSelect
        selected.setTitleColor(UIColor.white, for: .normal)
        unselected1.setTitleColor(colorSelect, for: .normal)
        unselected2.setTitleColor(colorSelect, for: .normal)
        unselected3.setTitleColor(colorSelect, for: .normal)
        unselected1.backgroundColor = colorNotSelect
        unselected2.backgroundColor = colorNotSelect
        unselected3.backgroundColor = colorNotSelect
    }
    
//    func setFalseValue(lb1: UIButton,lb2: UIButton, lb3: UIButton){
//        lb1.setTitle(options[0], for: .normal)
//        lb2.setTitle(options[1], for: .normal)
//        lb3.setTitle(options[2], for: .normal)
//    }
    
    func setFalseValue2(lb1: UIButton,lb2: UIButton, lb3: UIButton, ops: [String]){
        lb1.setTitle(ops[0], for: .normal)
        lb2.setTitle(ops[1], for: .normal)
        lb3.setTitle(ops[2], for: .normal)
    }
    
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
    func finishQuiz(){
        timer.invalidate()
        for i in 0..<systemArray.count {
            if systemArray[i] == playerArray[i]{
                result += 1;
            }
        }
        //push vc result
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Result_vc") as? ResultController
        vc?.myScore = result
        vc?.totalScore = systemArray.count
        vc?.cateid = cateid
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
            "duration" : MyDatabase.user.integer(forKey: keys.limit) - count,
            "time" : dateString,
            "categoryid" : cateid
        ]
        MyDatabase.ref.child("Result").child(newChild).setValue(newResult)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func clickNumber(_ sender: UIButton) {
        var index:Int = 0
        if let title = sender.titleLabel!.text,
            let intTitle = Int(title){
            index = intTitle - 1
//            setUpQuestionModel(with: testModel[index-1], index: index - 1)
//            currentQuestionIndex = index - 1
//            print(index)
//            currentButton = sender
//            setButtonSelectedState(button: sender)
            displayQuestionByNumber(index: index, button: sender)
        }
    }
    
    func displayQuestionByNumber(index: Int, button: UIButton){
        setUpQuestionModel(with: testModel[index], index: index)
        currentQuestionIndex = index
        currentButton = button
        setButtonSelectedState(button: button)
    }
    
    
}

