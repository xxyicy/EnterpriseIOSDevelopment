//
//  File.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 1/22/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit
import Firebase

class ConfirmAndCheckoutViewController : UIViewController {
    
    let toClaimOrderRef = FIRDatabase.database().reference(withPath: "order/to claim")
    let claimedOrderRef = FIRDatabase.database().reference(withPath: "order/claimed")
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    var drinks: [String] = []
    var drinkComments:[String] = []
    var drinkSizes: [String] = []
    var drinkPrices: [String] = []
    var snacks: [String] = []
    var snackPrices: [String] = []
    var totalPrices: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        
        let defaults = UserDefaults.standard
        locationLabel.text = String("\(defaults.object(forKey: "location") as! String) \(defaults.object(forKey: "room") as! String)")
        timeLabel.text = defaults.object(forKey: "time") as! String?
        setPrice()
        setOrderDetail()
    }
    
    func setPrice() {
        var counter: Double = 0.0
        for (s) in drinkPrices {
            counter += Double(s)!
        }
        for (s) in snackPrices {
            counter += Double(s)!
        }
        self.totalPrices = String(counter)
        priceLabel.text = String(counter)
        
    }
    
    //When click pay, push the order data to Firebase under "order/to claim/"
    @IBAction func confirmAndCheckOut(_ sender: Any) {
        //Push data
        let defaults = UserDefaults.standard
        let username = defaults.value(forKey: "username")
        let locationTemp = (defaults.value(forKey: "location") as! String) + " " + (defaults.value(forKey: "room") as! String)
        var drinkDic:Dictionary<String, Any> = [:]
        for (index,element) in self.drinks.enumerated() {
            drinkDic[element] = ["size": drinkSizes[index],
                                 "comment":drinkComments[index]]
        }
        let snackArr:NSArray = snacks as NSArray
        let priceDou: Double = Double(totalPrices)!
        let post = ["customer": username,
                    "drink quantity": drinks.count,
                    "snack quantity": snacks.count,
                    "location": locationTemp,
                    "time": defaults.value(forKey: "time"),
                    "drinks": drinkDic,
                    "snacks": snackArr,
                    "total price": priceDou,
                    "claimed":false,
                    "listened":false]
        let key = self.toClaimOrderRef.childByAutoId()
        key.setValue(post)
        
        //Show Activity Indicator
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        key.observe(FIRDataEventType.childChanged, with: { (snapshot) in
            if ((snapshot.value as! Bool) == true) {
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                key.child("listened").setValue(1)
                self.orderTakenConfirmation(post as NSDictionary)
            }
        })
    }
    
    
    func setOrderDetail() {
        var temp: String = ""
        if (drinks.count == 1) {
            temp = "1 drink"
        } else if (drinks.count > 1) {
            temp = String(drinks.count) + " drinks"
        }
        if (snacks.count == 1) {
            if (drinks.count == 0) {
                temp = "1 snack"
            } else {
            temp+=", 1 snack"
            }
        } else if (snacks.count > 1) {
            if (drinks.count == 0) {
                temp = String(snacks.count) + " snacks"
            } else {
                temp = temp + ", " + String(snacks.count) + " snacks"
            }
        }
        orderLabel.text = temp
    }
    
    @IBAction func backToLocationAndTime(_ sender: UIButton) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func backToOrderDetail(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func orderTakenConfirmation(_ value: NSDictionary) {
        let instruction = UIAlertController(title: "You order is taken. Go to order detail page?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        instruction.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (UIAlertAction) in
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let orderInfoViewController: OrderInfoViewController = storyboard.instantiateViewController(withIdentifier: "orderInfoPage") as! OrderInfoViewController
            orderInfoViewController.isDone = false
            orderInfoViewController.order = value
            
            self.navigationController?.pushViewController(orderInfoViewController, animated: true)
        }))
        instruction.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(instruction, animated: true, completion: nil)
    }
}
