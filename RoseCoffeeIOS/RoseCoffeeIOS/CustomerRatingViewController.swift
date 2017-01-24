//
//  CustomerRatingViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/23/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import Cosmos

class CustomerRatingViewController : UIViewController {
    
    @IBOutlet var ratingCosmosView: CosmosView!
    @IBOutlet var ratingTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ratingCosmosView.didFinishTouchingCosmos = { rating in
            self.ratingTextLabel.text = String(format: "%.1f", rating)
        }
        ratingCosmosView.settings.fillMode = .half
    }
    
}
