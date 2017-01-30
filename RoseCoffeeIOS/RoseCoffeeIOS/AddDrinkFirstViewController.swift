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
    
    let menuRef = FIRDatabase.database().reference(withPath: "menu")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3;
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        if (indexPath.item == 0) {
            label.text = "Espresso Drinks"
        } else if (indexPath.item == 1) {
            label.text = "Frappuccina Coffee"
        } else if (indexPath.item == 2) {
            label.text = "Frappuccino Creme"
        }
        cell.systemLayoutSizeFitting(CGSize(width: collectionView.bounds.size.width/2, height: collectionView.bounds.size.width/2))
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.item == 0) {
            OpenIndex("Espresso Drinks")
        } else if (indexPath.item == 1) {
            OpenIndex("Frappuccina Coffee")
        } else if (indexPath.item == 2) {
            OpenIndex("Frappuccino Creme")
        }
    }
    
    func OpenIndex(_ index: String) {
        
    }
    
}
