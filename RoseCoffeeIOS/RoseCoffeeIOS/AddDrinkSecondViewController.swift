//
//  AddDrinkSecondViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/30/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit
import Firebase

class AddDrinkSecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var CommentTextView: UITextField!
    var drinkRef = FIRDatabase.database().reference(withPath: "menu/drink")
    let defaults = UserDefaults.standard
    var sizeArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sizeArray = defaults.value(forKey: "tempSizes") as! [String]
        print(1)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(sizeArray.count)
        return sizeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sizeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.set(self.drinkRef.child(defaults.value(forKey: "tempDrink") as! String).value(forKey: sizeArray[row]), forKey: "PriceTemp")
    }
}
