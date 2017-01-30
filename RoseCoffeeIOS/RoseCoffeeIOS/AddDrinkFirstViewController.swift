//
//  AddDrinkFirstViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/28/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit
import Firebase

class AddDrinkFirstViewController: UICollectionViewController {
    
    let userRef = FIRDatabase.database().reference(withPath: "menu")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        if (indexPath.item == 1) {
            label.text = "Large/Vanti"
        } else if (indexPath.item == 2) {
            label.text = "Medium/Grantee"
        } else if (indexPath.item == 3) {
            label.text = "Small/Tall"
        } else {
            label.text = "error"
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
