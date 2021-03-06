//
//  MyCategoryController.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/9/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyCategoryController: UIViewController {

    
    
    @IBOutlet var btnRanking: UIBarButtonItem!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var indicatorView: UIView!
    @IBOutlet var centerIndicator: UIActivityIndicatorView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var heightConstraint: NSLayoutConstraint!
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Category"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        CategoryCell.registerCellByNib(categoryTableView)
        categoryTableView.dataSource = self
        indicatorView.backgroundColor = UIColor.clear
        retrieveDataCategory()
        heightConstraint.constant = 0
        indicator.isHidden = true
        
    }
    
    
    @IBAction func clickRanking(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Ranking_vc") as? MyRankingController
        vc?.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func setUpMenuButton(){
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 25, height: 25)
        menuBtn.setImage(UIImage(named:"ranking"), for: .normal)
        menuBtn.addTarget(self, action: #selector(viewRanking(_:)), for: UIControl.Event.touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    @objc func viewRanking(_ sender: UIBarButtonItem){
        
    }
    
    func retrieveDataCategory(){
        if categories.count == 0 {
            centerIndicator.startAnimating()
            categoryTableView.isHidden = true
            loadingView.isHidden = false
        }
        
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
                self.categoryTableView.isHidden = false
                self.centerIndicator.stopAnimating()
                self.centerIndicator.isHidden = true
                self.loadingView.isHidden = true
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
        indicator.startAnimating()
        refreshControl.beginRefreshing()
        indicator.isHidden = false
        heightConstraint.constant = 60
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.heightConstraint.constant = 0
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.refreshControl.endRefreshing()
        }
    }
    

}

extension MyCategoryController : UITableViewDataSource {
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

extension MyCategoryController : CategoryCellDelegate {
    func didTapButton(with title: String, cateid: Int) {
        if title == "View" {
            print(cateid)
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Question_vc") as? QuestionListViewController
            vc?.cateid = cateid
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Test_vc") as? MyTestController
            vc?.hidesBottomBarWhenPushed = true
            vc?.cateid = cateid
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}
