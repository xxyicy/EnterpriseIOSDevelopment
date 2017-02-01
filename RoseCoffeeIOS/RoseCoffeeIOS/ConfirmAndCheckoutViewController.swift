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
    var drinks: [String] = []
    var drinkComments:[String] = []
    var drinkSizes: [String] = []
    var drinkPrices: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        locationLabel.text = String("\(defaults.object(forKey: "location") as! String) \(defaults.object(forKey: "room") as! String)")
        timeLabel.text = defaults.object(forKey: "time") as! String?
        setPrice()
        setOrderDetail()
    }
    
    func setPrice() {
        var counter: Double = 0.0
        for (s) in drinkPrices {
            counter += Double(s)!
        }
        priceLabel.text = String(counter)
        
    }
    
    func setOrderDetail() {
        var temp: String = ""
        if (drinks.count == 1) {
            temp = "1 drink, "
        } else  {
            temp = String(drinks.count) + " drinks, "
        }
        orderLabel.text = temp
    }
    
    @IBAction func backToLocationAndTime(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func backToOrderDetail(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
