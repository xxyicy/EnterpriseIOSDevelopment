//
//  ConfirmDeliveryViewController.swift
//  RoseCoffeeIOS
//
//  Created by FangyuanWangon 2017/2/11.
//  Copyright © 2017年 Xinyu Xiao. All rights reserved.
//

import Foundation
import Firebase
import Cosmos
class ConfirmDeliveryViewController : UIViewController {
    //for customer confirm delivery
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet var ratingCosmosView: CosmosView!
    @IBOutlet var ratingTextLabel: UILabel!
    var order: NSDictionary = [:]
    
    let orderRef = FIRDatabase.database().reference(withPath: "order")
    let userRef = FIRDatabase.database().reference(withPath: "user")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingCosmosView.didFinishTouchingCosmos = { rating in
            self.ratingTextLabel.text = String(format: "%.1f", rating)
        }
        ratingCosmosView.settings.fillMode = .half
      
    }

    @IBAction func confirmDelivery(_ sender: Any) {
        //update order for rating
        let rating:Double = self.ratingCosmosView.rating
        let key:String = self.order.value(forKey: "key") as! String
        order.setValue(nil, forKey: "key")
        order.setValue(rating, forKey: "ratingForDelivery")
       
        let deliveredRef = self.orderRef.child("delivered").child(key)
        let price:Double = order.value(forKey: "total price") as! Double
        let defaults = UserDefaults.standard
        let username: String = defaults.object(forKey: "username") as! String
        
        deliveredRef.removeValue(completionBlock: { (error, refer) in
            if (error != nil){

            }else{
                self.orderRef.child("received").child(key).setValue(self.order)
                self.userRef.child(username).child("customer orders").child("in progress").child(key).setValue(nil)
                self.userRef.child(username).child("customer orders").child("done").child(key).setValue("received")
                
                
                
                self.userRef.child(username).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! NSDictionary
                    let balance = Double(value.object(forKey: "balance") as! String)!
                    self.userRef.child(username).child("balance").setValue(String(format:"%.2f",balance-price))
                })
                
                self.userRef.child(self.order.object(forKey: "deliveryPerson") as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! NSDictionary
                    let balance = Double(value.object(forKey: "balance") as! String)!
                    self.userRef.child(self.order.object(forKey: "deliveryPerson") as! String).child("balance").setValue(String(format:"%.2f",balance+price))
                })
                
                
                self.userRef.child(self.order.object(forKey: "deliveryPerson") as! String).child("delivery orders").child("done").child(key).setValue("received")
                self.userRef.child(self.order.object(forKey: "deliveryPerson") as! String).child("delivery orders").child("in progress").child(key).setValue(nil)

                
               deliveredRef.removeObserver(withHandle: 0)
            }
        })
         _ = navigationController?.popViewController(animated: true)
    }

    
    
    }

