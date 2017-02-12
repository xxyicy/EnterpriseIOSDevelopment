//
//  CustomerRatingViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/23/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import Cosmos
import Firebase

class CustomerRatingViewController : UIViewController {
    
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
    
    @IBAction func confirmRating(_ sender: Any) {
        let rating:Double = self.ratingCosmosView.rating
        print(order)
        let key:String = self.order.value(forKey: "key") as! String
        order.setValue(nil, forKey: "key")
        order.setValue(rating, forKey: "ratingForCustomer")
        
        order.setValue(1, forKey: "claimed")
        
        let claimedRef = self.orderRef.child("claimed").child(key)
        
        let defaults = UserDefaults.standard
        let username: String = defaults.object(forKey: "username") as! String
        
        claimedRef.removeValue(completionBlock: { (error, refer) in
            if (error != nil){
                
            }else{
                self.orderRef.child("delivered").child(key).setValue(self.order)
                self.userRef.child(username).child("delivery orders").child("in progress").child(key).setValue("delivered")
               
                self.userRef.child(self.order.object(forKey: "customer") as! String).child("customer orders").child("in progress").child(key).setValue("delivered")
                
                
                claimedRef.removeObserver(withHandle: 0)
            }
        })
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "MyOrdersNav") as! UINavigationController
        
        self.revealViewController().pushFrontViewController(navController, animated: true)
    }
}
