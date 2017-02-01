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

    let drinkRef = FIRDatabase.database().reference(withPath: "menu/drink")
    var keys: [String] = []
    var imageArray: [UIImage] = []
    var VCRef: OrderDetailViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drinkRef.observe(FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            self.keys = value.allKeys as! [String]
            for (_,data) in value {
                let temp = data as! NSDictionary
                let temp2 = temp.object(forKey: "image") as! String
                self.downloadImage(URL(string: temp2)!)
            }
            self.collectionView?.reloadData()
        })
        self.collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count;
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = self.keys[indexPath.item]
        cell.backgroundView = UIImageView(image:self.imageArray[indexPath.item])
        cell.frame = CGRect(x: CGFloat(indexPath.item % 2) * collectionView.bounds.size.width/2, y: 30 + CGFloat(indexPath.item/2) * collectionView.bounds.size.width/2, width: collectionView.bounds.size.width/2, height: collectionView.bounds.size.width/2)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.drinkRef.child(self.keys[indexPath.item]).observe(FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var sizes:[String] = []
            for (key,_) in value {
                let k: String = key as! String
                if (k != "image"){
                    sizes.append(key as! String)
                }
            }
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let modal: AddDrinkSecondViewController = storyboard.instantiateViewController(withIdentifier: "AddDrinkSecondView") as! AddDrinkSecondViewController
            modal.sizeArray = sizes
            modal.drinkName = self.keys[indexPath.item]
            modal.VCRef = self.VCRef
            modal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            self.present(modal, animated: true)
            
        })
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(_ url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                self.imageArray.append(UIImage(data: data)!)
            }
            self.collectionView?.reloadData()
        }
    }
}
