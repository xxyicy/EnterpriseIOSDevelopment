//
//  ProfileViewController.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 2/2/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import Firebase

class ProfileViewController : UIViewController {
    

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var phoneNumLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    let userRef = FIRDatabase.database().reference(withPath: "user")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var username: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userRef.child(username).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.nameLabel.text = value?["name"] as! String?
            self.emailLabel.text = value?["email"] as! String?
            self.phoneNumLabel.text = value?["phone number"] as! String?
        })
    }
    
}
