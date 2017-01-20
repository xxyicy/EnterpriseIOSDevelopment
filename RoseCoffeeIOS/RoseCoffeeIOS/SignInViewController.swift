//
//  SignInViewController.swift
//  RoseCoffeeIOS
//
//  Created by Fangyuan Wang on 2016/12/31.
//  Copyright © 2016年 Xinyu Xiao. All rights reserved.
//

import Foundation
import Rosefire
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let secret = "KkKMGtbQOhWZcr0ksKHN" as String
    let REGISTERY_TOKEN = "e3d9d1dd-8931-46fd-b41c-b02187ff1ddb" as String
    let userRef = FIRDatabase.database().reference(withPath: "rose-coffee-on-ios/user")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRApp.configure()
        
        Rosefire.sharedDelegate().uiDelegate = self
        
    }
    @IBAction func SignInAction(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let token = defaults.object(forKey: "user_token")
        if token != nil {
            userRef.child(token as! String).observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let isDelivery = value?["is delivery"] as? Bool
                if (isDelivery)! {
                    //Jump to customer main
                    self.login()
                } else {
                    //Change to delivery main page later
                    self.login()
                }
            })
        }else{
            Rosefire.sharedDelegate().signIn(registryToken: REGISTERY_TOKEN) { (err, result) in
                if err == nil {
                    defaults.set(result?.token, forKey: "user_token")
//                    ref.child("user").setValue()
                    self.getPhoneNumber()
                }else{
                    
                }
            }
        }
    }
    
    func login() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "customerMainNav") as! UINavigationController
        
        self.revealViewController().pushFrontViewController(navController, animated: true)
    }
    
    func getPhoneNumber() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "updateInfoView")
        
        self.revealViewController().pushFrontViewController(viewController, animated: true)
        
    }
}
