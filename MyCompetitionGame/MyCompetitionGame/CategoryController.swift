//
//  CategoryController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/3/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CategoryController: UIViewController {

    @IBOutlet var categoryTableView: UITableView!
    var categories = [Category]()
    var myChild = "Category"
    
    @IBOutlet var lbTest: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveDataCategory()
        print("hmm: \(categories.count)")
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        categoryTableView.register(nib, forCellReuseIdentifier: "CategoryCell")
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    
    
    func retrieveDataCategory(){
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
                        let category = Category(categoryid: categoryid!, name: name!)
                        self.categories.append(category)
                    }
                }
                DispatchQueue.main.async {
                    self.categoryTableView.reloadData()
                }
            }
        }
        
    }

}

extension CategoryController : UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
}

extension CategoryController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.delegate = self
        cell.setUp(data: categories[indexPath.row])
        return cell
    }
    
}

extension CategoryController : CategoryCellDelegate {
    func didTapButton(with title: String, cateid: Int) {
        if title == "View" {
                print("View")
            print(cateid)
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Question_vc") as? QuestionListViewController
            vc?.cateid = cateid
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                print("idk")
        }
    }
        
}

