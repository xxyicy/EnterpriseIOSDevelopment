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
    
    let cellReuseIdentifier = "myOrderTableViewCell"
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let orderRef = FIRDatabase.database().reference(withPath: "order")
    var receivedArray: [NSDictionary] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderRef.child("received").observe(FIRDataEventType.value, with: { (snapshot) in
            self.receivedArray = []
            for (_,value) in (snapshot.value as? NSDictionary)!{
                self.receivedArray.append((value as? NSDictionary)!)
            }
            self.tableView.reloadData()
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
        
        return self.receivedArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyOrdersTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MyOrdersTableViewCell
        
        var value:NSDictionary = self.receivedArray[indexPath.row]
        
        
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
}
