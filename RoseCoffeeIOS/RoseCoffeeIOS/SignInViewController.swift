//
//  SignInViewController.swift
//  RoseCoffeeIOS
//
//  Created by FengYizhi on 2016/12/31.
//  Copyright © 2016年 Xinyu Xiao. All rights reserved.
//

import Foundation

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    @IBAction func SignInAction(_ sender: UIButton) {
        if usernameTextField.text != "" {
            if passwordTextField.text == "1234" {
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "customerMainNav") as! UINavigationController
                
                self.revealViewController().pushFrontViewController(navController, animated: true)
                
            }
        }
    }
}
