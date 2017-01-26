//
//  LocationAndTimeViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/2/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit

class LocationAndTimeViewController : UIViewController, UITableViewDataSource,UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var locationAndTimeButton: UIButton!
    @IBOutlet weak var orderDetailButton: UIButton!
    @IBOutlet weak var confirmAndCheckOutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var roomLayout:NSDictionary = ["Apartment":["101","Other"],
                                   "Logan Library":["First Floor", "Second Floor"],
                                   "Blumberg":["101","Other"],
                                   "BSB":["101","Other"],
                                   "Crapo":["G101","Other"],
                                   "Deming":["101","Other"],
                                   "Mees":["101","Other"],
                                   "Monech":["A101","Other"],
                                   "Myers":["M101","Other"],
                                   "Percopo":["101","Other"],
                                   "Scharpenberg":["101","Other"],
                                   "Skinner":["101","Other"],
                                   "Speed":["101","Other"],
                                   "Olin":["O259","O257","O159","O157", "Other"]]
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(LocationAndTimeViewController.loadData),name:NSNotification.Name(rawValue: "load"), object: nil)

    }
    
    func loadData(notification: NSNotification){
        //load data here
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "load"), object:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let defaults = UserDefaults.standard
        if indexPath.row == 0 {
            cell.textLabel?.text = "Quick Order"
            cell.detailTextLabel?.text = "Lakeside 203 at 9 pm"
        }else if indexPath.row == 1 {
            cell.textLabel?.text = "Building"
            cell.detailTextLabel?.text = "Olin"
            if defaults.object(forKey: "location") != nil {
                cell.detailTextLabel?.text = defaults.object(forKey: "location") as! String?
            }
            
        }else if indexPath.row == 2 {
            cell.textLabel?.text = "Room"
            cell.detailTextLabel?.text = "000"
            if defaults.object(forKey: "room") != nil {
                cell.detailTextLabel?.text = defaults.object(forKey: "room") as! String?
            }
        }else{
            cell.textLabel?.text = "Time"
            cell.detailTextLabel?.text = "current time"
            if defaults.object(forKey: "time") != nil {
                cell.detailTextLabel?.text = defaults.object(forKey: "time") as! String?
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 1){
            selectBuilding()
        }
        if (indexPath.row == 2){
            selectRoom()
        }
        if (indexPath.row == 3){
            selectTime()
        }
    }
        
    func selectBuilding(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modal: LocationPickerViewController = storyboard.instantiateViewController(withIdentifier: "locationModal") as! LocationPickerViewController
        modal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        modal.type = "location"
        modal.pickerData = ["Apartment", "Blumberg", "BSB", "Crapo", "Deming", "Lakeside", "Logan Library", "Mees", "Monech", "Myers", "Olin", "Percopo", "Scharpenberg",  "Skinner", "Speed", "Other"]
        self.present(modal, animated: true)
    }
    
    func selectRoom(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modal: LocationPickerViewController = storyboard.instantiateViewController(withIdentifier: "locationModal") as! LocationPickerViewController
        modal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        modal.type = "room"
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "location") != nil {
            modal.pickerData = roomLayout.object(forKey: defaults.object(forKey: "location")) as! [String]
        }else{
            modal.pickerData = roomLayout.object(forKey: "Logan Library") as! [String]
        }
        self.present(modal, animated: true)
    }
    
    func selectTime(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modal: TimePickerViewController = storyboard.instantiateViewController(withIdentifier: "timeModal") as! TimePickerViewController
        modal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(modal, animated: true)
    }

}



