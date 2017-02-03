//
//  MenuController.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 12/8/16.
//  Copyright © 2016 Xinyu Xiao. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let view: UIView = UIView()
        view.backgroundColor = UIColor(red: 125.0, green: 19.0, blue: 23.0, alpha: 1.0)
        tableView.tableFooterView = view
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let image = appDelegate.profileImage {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.image = image
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 1){
            
            let isDelivery: Bool = appDelegate.isDelivery!
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let navController: UINavigationController
            if !isDelivery{
                navController = storyboard.instantiateViewController(withIdentifier: "customerMainNav") as! UINavigationController
            }else{
                navController = storyboard.instantiateViewController(withIdentifier: "deliveryMainNav") as! UINavigationController

            }
            self.revealViewController().pushFrontViewController(navController, animated: true)
        }
    }
}

