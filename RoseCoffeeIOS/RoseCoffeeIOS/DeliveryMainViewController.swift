//
//  DeliveryMainViewController.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 1/23/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit

class DeliveryMainViewController : UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
