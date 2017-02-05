//
//  AddDrinkSecondViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/30/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit
import Firebase



class AddDrinkSecondViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet var sizePickerView: UIPickerView!
    
    var VCRef: OrderDetailViewController? = nil
    var drinkRef = FIRDatabase.database().reference(withPath: "menu/drink")
    var sizeArray: [String] = []
    var drinkName : String = ""
    var selectedSize:String = ""
    var price: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentTextField.delegate = self
        self.sizePickerView.delegate = self
        self.sizePickerView.dataSource = self
        let position = 0
        self.selectedSize = self.sizeArray[position]
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeArray.count
    }
    
    
    @IBAction func finishSetting(_ sender: Any) {
        print("About to send new order data back!")
        VCRef?.passDrinkData(commentTextField.text!, drinkName, selectedSize, price)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedSize = sizeArray[row]
        drinkRef.child(drinkName).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.price = String(value?.value(forKey: self.selectedSize) as! Double)
        })
    }
}
