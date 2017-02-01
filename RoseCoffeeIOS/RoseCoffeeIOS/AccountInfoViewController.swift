//
//  AccountInfoViewController.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 12/8/16.
//  Copyright © 2016 Xinyu Xiao. All rights reserved.
//

import UIKit
import Firebase

class AccountInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var isDeliverySwitch: UISwitch!
    let imagePicker = UIImagePickerController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let userRef = FIRDatabase.database().reference(withPath: "user")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
        imagePicker.delegate = self
        
        self.isDeliverySwitch.setOn(appDelegate.isDelivery!, animated: true)
        self.nameLabel.text = appDelegate.name
        self.emailLabel.text = appDelegate.email
        self.phoneNumLabel.text = appDelegate.phoneNum
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeProfileImageBtnTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.image = pickedImage
            appDelegate.profileImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeDeliveryStatus(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        let username: String = defaults.object(forKey: "username") as! String
        appDelegate.isDelivery = sender.isOn
        userRef.child(username).child("is delivery").setValue(sender.isOn)
    }
    
    @IBAction func SignOutAction(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "username")
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "SignInView")
        
        self.revealViewController().pushFrontViewController(signInViewController, animated: true)
    }
    
}
