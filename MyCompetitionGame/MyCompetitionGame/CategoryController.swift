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
        //retrieveDataCategory()
        
        /*
         let nib = UINib(nibName: "MyCell", bundle: nil)
         tableView.register(nib, forCellReuseIdentifier: "MyCell")
         tableView.delegate = self
         tableView.dataSource = self
         */
        lbTest.text = "\(categories.count)"
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        categoryTableView.register(nib, forCellReuseIdentifier: "CategoryCell")
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    func retrieveDataCategory(){
        MyDatabase.ref.child(myChild).observeSingleEvent(of: .value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    print(snap.key)
                    let myKey = snap.key
                    MyDatabase.ref.child(self.myChild).child(myKey).observeSingleEvent(of: .value) { (mySnap) in
                        let value = snap.value as? NSDictionary
                        let categoryid = value?["categoryid"] as? Int
                        let name = value?["name"] as? String
                        let category = Category(categoryid: categoryid!, name: name!)
                        self.categories.append(category)
                        DispatchQueue.main.async {
                            self.categoryTableView.reloadData()
                        }
                    }
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
        //cell.setUp(data: locations[indexPath.row])
        cell.setUp(data: categories[indexPath.row])
        return cell
    }
}
