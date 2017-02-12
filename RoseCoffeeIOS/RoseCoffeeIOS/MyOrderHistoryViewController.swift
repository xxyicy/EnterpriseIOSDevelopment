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
            let list = snapshot.value as? NSArray
            
                let dispatch = DispatchGroup()
                dispatch.enter()
                var count = 0
                if (list != nil) {
                for value in list! {
                    self.orderRef.child("received").child(value as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as! NSDictionary
                        self.receivedArray.append(value)
                        count+=1
                        if (count == list?.count){
                            dispatch.leave()
                        }
                    })
                }
                dispatch.notify(queue: DispatchQueue.main, execute: {
                    self.tableView.reloadData()
                })
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
        let orderList: NSDictionary = value.object(forKey: "snack quantity") as! NSDictionary
        let drinkList: NSDictionary = value.object(forKey: "drink quantity") as! NSDictionary

        
        var menus: String = ""
        
        var count:NSInteger = 0;
        for key in orderList.allKeys {
            count = count+1
            let toAdd = key as! String
            menus = menus + toAdd
            let breakLine: String = ",  "
            menus = menus + breakLine
        }
        let strIndex:NSInteger = menus.characters.count
        let menuIndex = menus.index(menus.startIndex, offsetBy: strIndex-3)
        menus = menus.substring(to: menuIndex)

        cell.menuLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.menuLabel?.text = menus
        
        cell.menuLabel?.numberOfLines = 0
        
        
        
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let defaults = UserDefaults.standard
            let username = defaults.object(forKey: "username") as! String
            var order: String = ""
            if (appDelegate.isDelivery)!{
                order = "delivery orders"
            }else{
                order = "customer orders"
            }
            userRef.child(username).child(order).child("done").child(String(indexPath.row)).removeValue()
        }
    }
}
