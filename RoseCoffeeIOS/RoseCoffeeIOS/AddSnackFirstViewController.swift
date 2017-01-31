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
    var snackText : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        snackRef.observe(FIRDataEventType.value, with: { (snapshot) in
            self.snackText = []
            for value in (snapshot.value as? NSArray)!{
                self.snackText.append((value as? String)!)
            }
            self.collectionView?.reloadData()
        })
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return snackText.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = snackText[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
}
