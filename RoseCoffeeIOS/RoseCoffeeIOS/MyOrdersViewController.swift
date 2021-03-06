//
//  MyOrdersViewController.swift
//  RoseCoffeeIOS
//
//  Created by FengYizhi on 2017/2/1.
//  Copyright © 2017年 Xinyu Xiao. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MyOrdersViewController: UITableViewController{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let cellReuseIdentifier = "myOrderTableViewCell"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let orderRef = FIRDatabase.database().reference(withPath: "order")
    let userRef = FIRDatabase.database().reference(withPath: "user")
    var claimedArray: [NSDictionary] = []
    var deliveredArray: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        let defaults = UserDefaults.standard
        let username = defaults.object(forKey: "username") as! String
        var order: String = ""
        if (appDelegate.isDelivery)!{
            order = "delivery orders"
        }else{
            order = "customer orders"
        }
        userRef.child(username).child(order).child("in progress").observe(FIRDataEventType.value, with: { (snapshot) in
            self.claimedArray = []
            self.deliveredArray = []
            if (snapshot.exists()) {
                let list = snapshot.value as! NSDictionary
                let dispatch = DispatchGroup()
                dispatch.enter()
                var count = 0
                for (key,value) in list {
                    let state = value as! String
                    self.orderRef.child(state).child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        if (snapshot.exists()) {
                            let value = snapshot.value as! NSDictionary
                            value.setValue(snapshot.key, forKeyPath: "key")
                            
                            if (state == "claimed") {
                                self.claimedArray.append(value)
                            }else if (state == "delivered"){
                                self.deliveredArray.append(value)
                            }
                            count+=1
                            if (count == list.count){
                                dispatch.leave()
                            }
                        }
                    })
                }
                dispatch.notify(queue: DispatchQueue.main, execute: {
                    self.tableView.reloadData()
                })
            }else{
                self.tableView.reloadData()
            }
        })
        
        
        tableView.tableFooterView = UIView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return claimedArray.count + deliveredArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyOrdersTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MyOrdersTableViewCell
        
        var index = indexPath.row
        var value:NSDictionary

        if(index >= self.claimedArray.count){
            index = index - self.claimedArray.count
            value = deliveredArray[index]
            cell.statusLabel?.text = "Delivered"

        }else{
            value = claimedArray[indexPath.row]
            cell.statusLabel?.text = "Claimed"

        }

        cell.timeLabel?.text = value.object(forKey: "time") as! String?
        cell.locationLabel?.text = value.object(forKey: "location") as! String?
        
        let drink = value.object(forKey: "drink quantity")
        let snack = value.object(forKey: "snack quantity")
        if let drink = (drink as? NSInteger), let snack = (snack as? NSInteger) {
            switch drink {
            case 0:
                switch snack {
                case 0:
                    cell.menuLabel?.text = "No order!"
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
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if(indexPath.row >= claimedArray.count){
            //delivered orders
            let value = deliveredArray[indexPath.row-claimedArray.count]
            if(appDelegate.isDelivery)!{
                
                let profileViewController: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "profilePage") as! ProfileViewController
                profileViewController.username = value.object(forKey: "customer") as! String
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }else{
                let confirmViewController: ConfirmDeliveryViewController = storyboard.instantiateViewController(withIdentifier: "confirmDelivery") as! ConfirmDeliveryViewController
                confirmViewController.order = value
                
                self.navigationController?.pushViewController(confirmViewController, animated: true)
            }
            
        }else{
            
            let value = claimedArray[indexPath.row]
            
            if (appDelegate.isDelivery!){
                
                let deliveryConfirmViewController: OrderInfoViewController = storyboard.instantiateViewController(withIdentifier: "orderInfoPage") as! OrderInfoViewController
                deliveryConfirmViewController.order = value
                deliveryConfirmViewController.isDone = false
                deliveryConfirmViewController.buttonHidden = false
                
                self.navigationController?.pushViewController(deliveryConfirmViewController, animated: true)
            }else{
                let profileViewController: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "profilePage") as! ProfileViewController
                profileViewController.username = value.object(forKey: "deliveryPerson") as! String
                self.navigationController?.pushViewController(profileViewController, animated: true)
            }
            
            
        }
    }
}
