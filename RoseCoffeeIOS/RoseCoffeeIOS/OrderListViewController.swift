//
//  DeliveryMainViewController.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 1/23/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit

class OrderListViewController : UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    let cellReuseIdentifier = "order"
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:OrderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! OrderTableViewCell
        
        cell.byLabel?.text = "2"
        cell.toLabel?.text = "1"
        cell.menuTextField?.text = "3"
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(buttonClicked(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func buttonClicked(_ sender: UIButton){
        let alert = UIAlertController(title: "Do you want to take this order?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
}
