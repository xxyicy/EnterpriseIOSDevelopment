//
//  LocationAndTimeViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/2/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit

//struct Player {
//    var name: String?
//    var game: String?
//    var rating: Int
//    
//    init(name: String?, game: String?, rating: Int) {
//        self.name = name
//        self.game = game
//        self.rating = rating
//    }
//}
//
//let playersData = [
//    Player(name:"Bill Evans", game:"Tic-Tac-Toe", rating: 4),
//    Player(name: "Oscar Peterson", game: "Spin the Bottle", rating: 5),
//    Player(name: "Dave Brubeck", game: "Texas Hold 'em Poker", rating: 2) ]

class LocationAndTimeViewController : UIViewController {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var LocationAndTimeTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
//      self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 70, green: 13, blue: 14, alpha: 0)
    }
    
    
}
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return transportItems.count
//    }
