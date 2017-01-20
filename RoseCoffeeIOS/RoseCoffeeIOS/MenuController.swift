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

        if let image = appDelegate.profileImage {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.image = image
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignOutAction(_ sender: UIButton) {
        
    }
    
}

