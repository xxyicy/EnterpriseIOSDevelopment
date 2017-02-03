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
            let list = snapshot.value as! NSDictionary
            let dispatch = DispatchGroup()
            dispatch.enter()
            var count = 0
            for (key,value) in list {
                let state = value as! String
                self.orderRef.child(value as! String).child(key as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as! NSDictionary
                    if (state == "claimed"){
                        self.claimedArray.append(value)
                    }else{
                        self.deliveredArray.append(value)
                    }
                    count+=1
                    if (count == list.count){
                        dispatch.leave()
                    }
                })
            }
            dispatch.notify(queue: DispatchQueue.main, execute: {
                self.tableView.reloadData()
            })
            
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
        let orderList: NSDictionary = value.object(forKey: "order list") as! NSDictionary
    
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
        if(indexPath.row >= claimedArray.count){
            //
            
        }else{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let profileViewController: ProfileViewController = storyboard.instantiateViewController(withIdentifier: "profilePage") as! ProfileViewController
            let value = claimedArray[indexPath.row]
            if (appDelegate.isDelivery!){
                profileViewController.username = value.object(forKey: "customer") as! String
            }else{
                profileViewController.username = value.object(forKey: "deliveryPerson") as! String
            }
            
            self.navigationController?.pushViewController(profileViewController, animated: true)
        }
    }
}
