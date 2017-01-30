//
//  LocationPickerViewController.swift
//  RoseCoffeeIOS
//
//  Created by Xinyu Xiao on 1/25/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import Foundation

class LocationPickerViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIView!
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = []
    var selectedLocation: String = ""
    var type: String = "location"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.layer.cornerRadius = 10
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        let defaults = UserDefaults.standard
        
        var position = 0
        if defaults.object(forKey: type) != nil {
            if (pickerData.contains(defaults.object(forKey: type) as! String)) {
                position = pickerData.index(of: defaults.object(forKey: type) as! String)!
            }
        }
        selectedLocation = pickerData[position]
        self.picker.selectRow(position, inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLocation = pickerData[row]
    }
    
    @IBAction func dismissViewController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveLocation(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.set(selectedLocation, forKey: type)
        if (type == "location"){
            defaults.removeObject(forKey: "room")
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}
