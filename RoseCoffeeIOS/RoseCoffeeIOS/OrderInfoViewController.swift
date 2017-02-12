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
    
    @IBOutlet weak var rateButton: UIButton!
    
    @IBOutlet weak var deliveryPersonRating: UILabel!
    @IBOutlet weak var customerRating: UILabel!
    let userRef = FIRDatabase.database().reference(withPath: "user")
    var order: NSDictionary = [:]
    var isDone: Bool = true
    var orderConfirmed: Bool = false
    var buttonHidden = true;
    
    override func viewDidLoad() {
        
        rateButton.isHidden = buttonHidden
        
        if (orderConfirmed){
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToMyDeliver))
        }

        userRef.child(order.object(forKey: "customer") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            self.customerLabel.text = value.object(forKey: "name") as! String?
            if (self.orderConfirmed){
                let price = self.order.object(forKey: "total price") as! Float
                let balance = value.object(forKey: "balance") as! Float
                self.userRef.child(self.order.object(forKey: "customer") as! String).child("balance").setValue(String(format: "%.2f", balance-price))
            }
        })
        
        if (order.object(forKey: "deliveryPerson") != nil) {
        
        userRef.child(order.object(forKey: "deliveryPerson") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as! NSDictionary
            self.deliveryPersonLabel.text = value.object(forKey: "name") as! String?
            
            if (self.orderConfirmed){
                let price = self.order.object(forKey: "total price") as! Double
                let balance = value.object(forKey: "balance") as! Double
                self.userRef.child(self.order.object(forKey: "deliveryPerson") as! String).child("balance").setValue(String(format: "%.2f", balance+price))
            }

            
            })
        } else {
            self.deliveryPersonLabel.text = "Don't know"
        }
        
        
        timeLabel.text = order.object(forKey: "time") as! String?
        locationLabel.text = order.object(forKey: "location") as! String?
        priceLabel.text = String(order.object(forKey: "total price") as! Double)
        var orderDetail: String = ""
        var orderList = order.object(forKey: "drinks")
        if (orderList != nil) {
            for (key,val) in (orderList as! NSDictionary) {
                let size = (val as! NSDictionary).object(forKey:"size") as! String
                let comment = (val as! NSDictionary).object(forKey:"comment") as! String
                orderDetail = orderDetail + (key as! String) + " - " + size + " - "+comment+"\n"
            }
        }
        orderList = order.object(forKey: "snacks")
        if (orderList != nil) {
            for key in (orderList as! NSArray) {
                orderDetail = orderDetail + (key as! String)
                orderDetail = orderDetail + "\n"
            }
        }
        orderLabel.text = orderDetail
        if let comment = order.object(forKey: "comment") as! String? {
            commentsTextView.text = comment
        }else{
            commentsTextView.text = "No comment"
        }
        
        if isDone {
//            customerRating.text = "5.0"
//            deliveryPersonRating.text = "5.0"
        }else{
            customerRating.text = "Not rate yet"
            deliveryPersonRating.text = "Not rate yet"

        }
        
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let deliveryConfirmViewController: CustomerRatingViewController = storyboard.instantiateViewController(withIdentifier: "deliveryRating") as! CustomerRatingViewController
        deliveryConfirmViewController.order = self.order
        
        self.navigationController?.pushViewController(deliveryConfirmViewController, animated: true)
        
    }
    func backToMyDeliver(){
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
