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
    
    let snackRef = FIRDatabase.database().reference(withPath: "menu/snack")
    var VCRef: OrderDetailViewController? = nil
    var snackText : [String] = []
    var imageArray:[UIImage] = []
    var priceArray: [Double] = []
    var count: NSInteger = 0
    var totalNum: NSInteger = 0
    let dispatch = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        snackRef.observe(FIRDataEventType.value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            self.count = 0
            self.dispatch.enter()
            self.totalNum = value.count
            for (key,data) in value {
                let temp = data as! NSDictionary
                let temp2 = temp.object(forKey: "image") as! String
                self.downloadImage(URL(string: temp2)!)
                self.snackText.append(key as! String)
                self.priceArray.append(temp.object(forKey: "price") as! Double)
            }
            self.dispatch.notify(queue: DispatchQueue.main, execute: {
                self.collectionView?.reloadData()
            })
            
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(1) as! UILabel
        label.text = self.snackText[indexPath.item]
        cell.backgroundView = UIImageView(image:self.imageArray[indexPath.item])
        cell.frame = CGRect(x: CGFloat(indexPath.item % 2) * collectionView.bounds.size.width/2, y: 30 + CGFloat(indexPath.item/2) * collectionView.bounds.size.width/2, width: collectionView.bounds.size.width/2, height: collectionView.bounds.size.width/2)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("About to pass back the snack chosen")
        self.VCRef?.passSnackData(self.snackText[indexPath.item], String(self.priceArray[indexPath.item]))
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in completion(data, response, error)
                self.count += 1
            if (self.count == self.totalNum){
                self.dispatch.leave()
            }
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
