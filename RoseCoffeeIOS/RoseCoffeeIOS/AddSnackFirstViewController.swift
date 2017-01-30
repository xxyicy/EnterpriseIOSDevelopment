//
//  AddDrinkFirstViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/28/17.
//  Copyright © 2017 Zhiqiang Qiu. All rights reserved.
//

import UIKit
import Firebase

class AddSnackFirstViewController: UICollectionViewController {
    
    let snackRef = FIRDatabase.database().reference(withPath: "menu/snacktest")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snackRef.accessibilityElementCount()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = snackRef.value(forKey: String(indexPath.item)) as! String?
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
}
