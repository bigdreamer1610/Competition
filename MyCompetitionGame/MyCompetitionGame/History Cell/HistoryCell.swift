//
//  HistoryCell.swift
//  MyCompetitionGame
//
//  Created by THUY Nguyen Duong Thu on 9/7/20.
//  Copyright © 2020 THUY Nguyen Duong Thu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class InsetLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 5, left: 7, bottom: 5, right: 7)
        super.drawText(in: rect.inset(by: insets))
    }
}

class HistoryCell: UITableViewCell {


    
    @IBOutlet var lbTime2: UILabel!
    @IBOutlet var backView: UIView!
    
    @IBOutlet var lbCategory: UILabel!
    @IBOutlet var lbTime: UILabel!
    @IBOutlet var lbScore: UILabel!
    var categories = [Category]()
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeLayout()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    func customizeLayout(){
        backView.backgroundColor = UIColor.init(displayP3Red: 122, green: 134, blue: 125, alpha: 1)
        backView.layer.shadowRadius = 20
        backView.layer.cornerRadius = 20
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func convertToDate(resultDate: String) -> DateComponents {
        let myDate = resultDate
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        let date = dateFormatter.date(from: myDate)
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: date!)
        return components
    }
    func setUpData(with data: Result){
        //convert to date
        let components = convertToDate(resultDate: data.time)
        var myList = [Category]()
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
                        myList.append(category)
                    }
                }
                self.categories = myList
                var cateName = ""
                for c in self.categories {
                    if c.categoryid == data.categoryid {
                        cateName = c.name
                    }
                }
                self.lbScore.text = "Score: \(data.result)"
                self.lbCategory.text = "Category: \(cateName)"
                let timeString = "\(components.hour!):\(components.minute!)"
                let dateString = "\(components.day!)-\(components.month!)-\(components.year!)"
                self.lbTime.text = "\(dateString)"
                self.lbTime2.text = "\(timeString)"
            }
        }
        
        
    }
    
    
    
}
