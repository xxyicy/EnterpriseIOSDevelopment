//
//  EditProfileViewController.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 1/24/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import Foundation
import Firebase

class EditProfileViewController : UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    let userRef = FIRDatabase.database().reference(withPath: "user")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        let username: String = defaults.object(forKey: "username") as! String
        userRef.child(username).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as! String?
            let nameArr = name?.components(separatedBy: " ")
            self.firstNameTextField.text = nameArr?[0]
            self.lastNameTextField.text = nameArr?[1]
            self.emailTextField.text = value?["email"] as! String?
            self.phoneNumTextField.text = value?["phone number"] as! String?
        })
    }
    
    @IBAction func saveChange(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        let username: String = defaults.object(forKey: "username") as! String
    
        self.userRef.child(username).child("name").setValue(self.firstNameTextField.text! + " " + self.lastNameTextField.text!)
        
        self.userRef.child(username).child("email").setValue(self.emailTextField.text!)
        
        self.userRef.child(username).child("phone number").setValue(self.phoneNumTextField.text!)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "AccountInfoNav") as! UINavigationController
    
        self.revealViewController().pushFrontViewController(navController, animated: true)
    }
    
    @IBAction func cancelChange(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}
