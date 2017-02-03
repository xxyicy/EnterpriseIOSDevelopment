//
//  OrderInfoViewController.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 2/2/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import Firebase

class OrderInfoViewController : UIViewController {
    
    @IBOutlet weak var customerLabel: UILabel!
    @IBOutlet weak var deliveryPersonLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var commentsTextView: UITextView!
    
    @IBOutlet weak var deliveryPersonRating: UILabel!
    @IBOutlet weak var customerRating: UILabel!
    let userRef = FIRDatabase.database().reference(withPath: "user")
    var order: NSDictionary = [:]
    var isDone: Bool = true
    
    override func viewDidLoad() {

        self.navigationItem.title = "Order Info"

        userRef.child(order.object(forKey: "customer") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            self.customerLabel.text = value.object(forKey: "name") as! String?
        })
        
        userRef.child(order.object(forKey: "deliveryPerson") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            self.deliveryPersonLabel.text = value.object(forKey: "name") as! String?
        })
        
        timeLabel.text = order.object(forKey: "time") as! String?
        locationLabel.text = order.object(forKey: "location") as! String?
//        priceLabel.text = "0"
        var orderDetail: String = ""
        let orderList = order.object(forKey: "order list") as! NSDictionary
        for (key,val) in orderList {
            let number = (val as! NSDictionary).object(forKey:"quantity") as! NSNumber
            orderDetail = orderDetail + String(describing: number)
            orderDetail = orderDetail + " "
            orderDetail = orderDetail + (key as! String)
            orderDetail = orderDetail + "\n"
        }
        orderLabel.text = orderDetail
        if let comment = order.object(forKey: "comment") as! String? {
            commentsTextView.text = comment
        }else{
            commentsTextView.text = "NO COMMENTS"
        }
        
        if isDone {
//            customerRating.text = "5.0"
//            deliveryPersonRating.text = "5.0"
        }else{
            customerRating.text = "Not Rate Yet"
            deliveryPersonRating.text = "Not Rate Yet"

        }
        
    }
}
