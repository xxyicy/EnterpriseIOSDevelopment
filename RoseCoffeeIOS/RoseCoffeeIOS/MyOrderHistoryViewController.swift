//
//  MyOrderHistoryViewController.swift
//  RoseCoffeeIOS
//
//  Created by FengYizhi on 2017/2/1.
//  Copyright © 2017年 Xinyu Xiao. All rights reserved.
//

import Foundation

import UIKit
import Firebase

class MyOrderHistoryViewController: UITableViewController{
    
    let cellReuseIdentifier = "orderHistoryTableViewCell"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let orderRef = FIRDatabase.database().reference(withPath: "order")
    let userRef = FIRDatabase.database().reference(withPath: "user")
    var receivedArray: [NSDictionary] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let username = defaults.object(forKey: "username") as! String
        var order: String = ""
        if (appDelegate.isDelivery)!{
            order = "delivery orders"
        }else{
            order = "customer orders"
        }
        let historyRef = userRef.child(username).child(order).child("done")
        
        historyRef.observe(FIRDataEventType.value, with: { (snapshot) in
            self.receivedArray = []
            if (snapshot.exists()) {
                let list = snapshot.value as! NSDictionary
                let dispatch = DispatchGroup()
                dispatch.enter()
                var count = 0
                for (key,value) in list {
                    self.orderRef.child(value as! String).child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        if (snapshot.exists()) {
                            let value = snapshot.value as! NSDictionary
                            self.receivedArray.append(value)
                            
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
        print(self.receivedArray)
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.receivedArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyOrdersTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MyOrdersTableViewCell
        
        let value:NSDictionary = self.receivedArray[indexPath.row]
        
        
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
        let orderInfoViewController: OrderInfoViewController = storyboard.instantiateViewController(withIdentifier: "orderInfoPage") as! OrderInfoViewController
        let value = receivedArray[indexPath.row]
        
        orderInfoViewController.order = value
        
        self.navigationController?.pushViewController(orderInfoViewController, animated: true)
        
    }

}
