//
//  LocationAndTimeViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/2/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit

class LocationAndTimeViewController : UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var locationAndTimeButton: UIButton!
    @IBOutlet weak var orderDetailButton: UIButton!
    @IBOutlet weak var confirmAndCheckOutButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 49, green: 8, blue: 7, alpha: 0)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "Quick Order")
        cell.accessoryType = .disclosureIndicator
        if indexPath.row == 0 {
            cell.textLabel?.text = "Quick Order"
            cell.detailTextLabel?.text = "Lakeside 203 at 9 pm"
        }else if indexPath.row == 1 {
            cell.textLabel?.text = "Building"
            cell.detailTextLabel?.text = "Olin"
        }else if indexPath.row == 2 {
            cell.textLabel?.text = "Room"
            cell.detailTextLabel?.text = "000"
        }else{
            cell.textLabel?.text = "Time"
            cell.detailTextLabel?.text = "current time"
        }
        return cell
    }
    
}

