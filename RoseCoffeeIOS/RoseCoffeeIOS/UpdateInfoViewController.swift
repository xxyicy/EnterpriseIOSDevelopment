//
//  UpdateInfoViewController.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 1/22/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import Foundation
import Firebase

class updateInfoViewController : UIViewController {
    @IBOutlet weak var phoneNumTextField: UITextField!
    let userRef = FIRDatabase.database().reference(withPath: "user")

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func updateInfo(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let username = defaults.object(forKey: "username")
        userRef.child(username as! String).child("phone number").setValue(phoneNumTextField.text)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "customerMainNav") as! UINavigationController
        
        self.revealViewController().pushFrontViewController(navController, animated: true)
    }
}

