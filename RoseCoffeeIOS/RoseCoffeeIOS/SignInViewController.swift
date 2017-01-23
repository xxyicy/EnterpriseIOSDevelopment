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
    let userRef = FIRDatabase.database().reference(withPath: "user")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Rosefire.sharedDelegate().uiDelegate = self
        
    }
    @IBAction func SignInAction(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let username = defaults.object(forKey: "username")
        if username != nil {
            self.presentMain(username: username as! String)
        }else{
            Rosefire.sharedDelegate().signIn(registryToken: REGISTERY_TOKEN) { (err, result) in
                if err == nil {
                    let username: String = (result?.username)!
                    defaults.set(username,forKey:"username")
                    self.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.hasChild(username) {
                            self.userRef.child(username).child("token").setValue(result?.token)
                            self.presentMain(username: username)
                        }else{
                            let userObject = ["is delivery": false,"token":(result?.token)!, "name": (result?.name)!, "email":(result?.email)!] as [String : Any]
                            self.userRef.child(username).setValue(userObject)
                            defaults.set(false, forKey: "isDelivery")
                            self.getPhoneNumber()
                        }
                    })
                    
                }else{
                    print("Firebase Sign In Failed")
                }
            }
        }
    }
    
    func presentMain(username: String) {
        userRef.child(username).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            let isDelivery = value?["is delivery"] as? Bool
            UserDefaults.standard.set(isDelivery, forKey: "isDelivery")
            if (isDelivery)! {
                //Jump to delivery main
                self.presentDeliveryMain()
                
            } else {
                //Change to customer main page later
                self.presentCustomerMain()
            }
        })
    }
    
    func presentCustomerMain() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "customerMainNav") as! UINavigationController
        navController.navigationBar.isTranslucent = false;
        self.revealViewController().pushFrontViewController(navController, animated: true)
    }
    
    func presentDeliveryMain() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "deliveryMainNav") as! UINavigationController
        navController.navigationBar.isTranslucent = false;

        self.revealViewController().pushFrontViewController(navController, animated: true)    }
    
    func getPhoneNumber() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "updateInfoView")
        
        self.revealViewController().pushFrontViewController(viewController, animated: true)
        
    }
}
