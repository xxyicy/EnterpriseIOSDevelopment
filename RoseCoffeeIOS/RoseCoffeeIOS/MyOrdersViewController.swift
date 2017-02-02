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
    var claimedArray: [NSDictionary] = []
    var deliveredArray: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        orderRef.child("claimed").observe(FIRDataEventType.value, with: { (snapshot) in
            self.claimedArray = []
            for (_,value) in (snapshot.value as? NSDictionary)!{
                if(self.appDelegate.isDelivery)!{
                    //check how to get the value of deliveryPerson
                    for child in snapshot.children {
                        
                        let key = (child as! FIRDataSnapshot).key as FIRDataSnapshot
                        
                        let text = key.object
                        if(key == "deliveryPerson"){
                            if(text == self.appDelegate.userName){
                                self.claimedArray.append((value as? NSDictionary)!)
                            }
                        }
                    }
                }else{
                    self.claimedArray.append((value as? NSDictionary)!)}
            }
            self.tableView.reloadData()
        })
        
        orderRef.child("delivered").observe(FIRDataEventType.value, with: {(snapshot) in
            self.deliveredArray = []
            for(_,value) in (snapshot.value as? NSDictionary)! {
                if(self.appDelegate.isDelivery)!{
                    //check how to get the value of deliveryPerson

                    for child in snapshot.children {
                        
                        let key = (child as! FIRDataSnapshot).key as String
                        let text = (child as? FIRDataSnapshot)?.value as! String
                        if(key == "deliveryPerson"){
                            if(text == self.appDelegate.userName){
                                self.deliveredArray.append((value as? NSDictionary)!)
                            }
                        }
                    }
                }else{
                    self.deliveredArray.append((value as? NSDictionary)!)}
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
        let total:NSInteger = claimedArray.count + deliveredArray.count
        return total
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
        // for displaying quantity of each order
//        for(itemName, itemInfo) in orderList{
//            let toAdd:String = itemName as! String
//            for(key, keyValue) in itemInfo as! NSDictionary{
//                if(key as! String == "quantity"){
//                    let quantity = keyValue as! Double}
//
//            }
//            
//        }
        cell.menuLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.menuLabel?.text = menus

        cell.menuLabel?.numberOfLines = 0
        
        
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}
