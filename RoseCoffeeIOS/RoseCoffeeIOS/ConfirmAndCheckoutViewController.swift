//
//  File.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 1/22/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit

class ConfirmAndCheckoutViewController : UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        locationLabel.text = String("\(defaults.object(forKey: "location") as! String) \(defaults.object(forKey: "room") as! String)")
        timeLabel.text = defaults.object(forKey: "time") as! String?
        priceLabel.text = defaults.object(forKey: "PriceTemp") as! String?
    }
    
    @IBAction func backToLocationAndTime(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func backToOrderDetail(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
