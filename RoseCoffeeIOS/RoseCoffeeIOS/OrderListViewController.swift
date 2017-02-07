//
//  DeliveryMainViewController.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 1/23/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit
import Firebase

class OrderListViewController : UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    let cellReuseIdentifier = "order"
    let orderRef = FIRDatabase.database().reference(withPath: "order")
    let userRef = FIRDatabase.database().reference(withPath: "user")
    var toClaimArray: [NSDictionary] = []
    var keyArray: [String] = []
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            print(self.revealViewController())

            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        orderRef.child("to claim").observe(FIRDataEventType.value, with: { (snapshot) in
            self.toClaimArray = []
            
            if (snapshot.value as? NSDictionary) != nil {
                for (key,value) in (snapshot.value as? NSDictionary)!{
                    self.keyArray.append(key as! String)
                    self.toClaimArray.append((value as! NSDictionary))
                }
            }
            
            
            self.tableView.reloadData()
        })
       
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toClaimArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:OrderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! OrderTableViewCell
        
        let value:NSDictionary = toClaimArray[indexPath.row]
        cell.timeLabel?.text = value.object(forKey: "time") as! String?
        cell.locationLabel?.text = value.object(forKey: "location") as! String?
        let drink: NSNumber = value.object(forKey: "drink quantity") as! NSNumber
        let snack: NSNumber = value.object(forKey: "snack quantity") as! NSNumber
        switch drink {
        case 0:
            switch snack {
            case 0:
                cell.menuLabel?.text = ""
            case 1:
                cell.menuLabel?.text = "1 snack"
            default:
                cell.menuLabel?.text = "\(snack) snacks"
            }
        case 1:
            switch snack {
            case 0:
                cell.menuLabel?.text = "1 drink"
            case 1:
                cell.menuLabel?.text = "1 drink, 1 snack"
            default:
                cell.menuLabel?.text = "1 drink, \(snack) snacks"
            }

        default:
            switch snack {
            case 1:
                cell.menuLabel?.text = "\(drink) drinks, 1 snack"
            default:
                cell.menuLabel?.text = "\(drink) drinks, \(snack) snacks"
            }
        }
        
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func buttonClicked(_ sender: UIButton){
        let alert = UIAlertController(title: "Do you want to take this order?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
            let defaults = UserDefaults.standard
            let username = defaults.object(forKey: "username") as! String
            let value = self.toClaimArray[sender.tag]
            value.setValue(username, forKey: "deliveryPerson")
            let toClaimRef = self.orderRef.child("to claim").child(self.keyArray[sender.tag])
            print(toClaimRef.key)
            
            toClaimRef.child("claimed").setValue(true)
            
            
            toClaimRef.removeValue(completionBlock: { (error, refer) in
                
                if (error != nil){
                    alert.dismiss(animated: true, completion: nil)
                    self.errorOccur()
                }else{
                    self.orderRef.child("claimed").child(self.keyArray[sender.tag]).setValue(value)
                    self.userRef.child(username).child("delivery orders").child("in progress").child(self.keyArray[sender.tag]).setValue("claimed")
                    self.userRef.child(value.object(forKey: "customer") as! String).child("customer orders").child("in progress").child(self.keyArray[sender.tag]).setValue("claimed")
                    alert.dismiss(animated: true, completion: nil)
                    self.takeOrderConfirmation(value)
                }
            })
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    func errorOccur(){
        let instruction = UIAlertController(title: "Sorry, this order expired or has be taken by someone else.", message: "", preferredStyle: UIAlertControllerStyle.alert)
        instruction.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(instruction, animated: true, completion: nil)
    }
    
    func takeOrderConfirmation(_ value: NSDictionary) {
        let instruction = UIAlertController(title: "You successfully take the order, Go to order detail page?", message: "", preferredStyle: UIAlertControllerStyle.alert)
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
