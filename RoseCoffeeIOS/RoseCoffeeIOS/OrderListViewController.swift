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
    var toClaimArray: [NSDictionary] = []
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        orderRef.child("to claim").observe(FIRDataEventType.value, with: { (snapshot) in
            self.toClaimArray = []
            for (_,value) in (snapshot.value as? NSDictionary)!{
                self.toClaimArray.append((value as? NSDictionary)!)
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
        let drink: NSInteger = value.object(forKey: "drink quantity") as! NSInteger
        let snack: NSInteger = value.object(forKey: "snack quantity") as! NSInteger
        switch drink {
        case 0:
            switch snack {
            case 1:
                cell.menuLabel?.text = "1 snack"
            default:
                cell.menuLabel?.text = "\(snack) snacks"
            }
        case 1:
            switch snack {
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
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
}
