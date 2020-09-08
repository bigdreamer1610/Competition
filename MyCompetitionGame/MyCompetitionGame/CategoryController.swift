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

struct Item {
    var imageName: String
}
class CategoryController: UIViewController {
    
    @IBOutlet var categoryTableView: UITableView!
    var categories = [Category]()
    var myChild = "Category"
    var items: [Item] = [Item(imageName: "back1"),
                            Item(imageName: "back2"),
                            Item(imageName: "back3"),
                            Item(imageName: "back4"),
                            Item(imageName: "back5"),
                            Item(imageName: "back6"),
                            Item(imageName: "back7"),
                            Item(imageName: "back8")]

    var refreshControl = UIRefreshControl()
    @IBOutlet var indicatorView: UIView!
    @IBOutlet var indicator: UIActivityIndicatorView!

    @IBOutlet var heightConstant: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.backgroundColor = UIColor.clear
        retrieveDataCategory()
        heightConstant.constant = 0
        indicator.isHidden = true
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        categoryTableView.register(nib, forCellReuseIdentifier: "CategoryCell")
        categoryTableView.dataSource = self
        
    }
    func retrieveDataCategory(){
        var myCategories = [Category]()
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
                        myCategories.append(category)
                    }
                }
                self.categories = myCategories
                self.addRefreshControl()
                self.categoryTableView.reloadData()
            }
        }
        
    }
    
    func addRefreshControl(){
        self.refreshControl.tintColor = UIColor.clear
        self.refreshControl.alpha = 0
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        self.refreshControl.attributedTitle = NSAttributedString(string: "", attributes: attributes)
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControl.Event.valueChanged)
        self.categoryTableView.addSubview(self.refreshControl)
    }
    
    @objc func refresh(_ sender: UIRefreshControl){
        retrieveDataCategory()
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
    
}

extension CategoryController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.delegate = self
        cell.setUp(data: categories[indexPath.row])
        cell.cateImage.image = UIImage(named: items[indexPath.item].imageName)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
}

extension CategoryController : CategoryCellDelegate {
    func didTapButton(with title: String, cateid: Int) {
        if title == "View" {
            print(cateid)
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Question_vc") as? QuestionListViewController
            vc?.cateid = cateid
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Test_vc") as? TestController
            vc?.cateid = cateid
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}

