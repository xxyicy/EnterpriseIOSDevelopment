//
//  File.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 1/22/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit

class ConfirmAndCheckoutViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backToLocationAndTime(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func backToOrderDetail(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
