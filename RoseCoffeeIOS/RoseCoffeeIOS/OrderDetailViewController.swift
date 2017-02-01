//
//  OrderDetailViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/9/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit


//
//  LocationAndTimeViewController.swift
//  RoseCoffeeIOS
//
//  Created by Zhiqiang Qiu on 1/2/17.
//  Copyright © 2017 Xinyu Xiao. All rights reserved.
//

import UIKit
import Firebase

protocol passOrderDetail {
    func passData(_ comment: String, _ drinkName: String, _ drinkSize: String, _ drinkPrice: String)
}

class OrderDetailViewController : UIViewController, UITableViewDataSource,UITableViewDelegate, passOrderDetail{
    @IBOutlet var AddDrinkButton: UIImageView!
    @IBOutlet var AddSnackButton: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var drinks: [String] = []
    var drinkComments:[String] = []
    var drinkSizes: [String] = []
    var drinkPrices: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        let addDrinkGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(addDrink(img: )))
        AddDrinkButton.isUserInteractionEnabled = true
        AddDrinkButton.addGestureRecognizer(addDrinkGestureRecognizer)
        let addSnackGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(addSnack(img: )))
        AddSnackButton.isUserInteractionEnabled = true
        AddSnackButton.addGestureRecognizer(addSnackGestureRecognizer)
        
        
    }
    
    @IBAction func goToNextPage(_ sender: Any) {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "CustomerConfirmandCheckOut") as! ConfirmAndCheckoutViewController
        nextViewController.drinks = self.drinks
        nextViewController.drinkComments = self.drinkComments
        nextViewController.drinkSizes = self.drinkSizes
        nextViewController.drinkPrices = self.drinkPrices
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func addDrink(img: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modal: AddDrinkFirstViewController = storyboard.instantiateViewController(withIdentifier: "AddDrinkModal") as! AddDrinkFirstViewController
        modal.VCRef = self
        modal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(modal, animated: true)
    }
    
    func addSnack(img: AnyObject) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let modal: AddSnackFirstViewController = storyboard.instantiateViewController(withIdentifier: "AddSnackModal") as! AddSnackFirstViewController
        modal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(modal, animated: true)
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath)
        var tempText = drinks[indexPath.row]
        if (tempText.characters.count >= 12) {
            let index = tempText.index(tempText.startIndex, offsetBy: 5)
            tempText = tempText.substring(to: index) + ".."
        }
        cell.textLabel?.text = tempText + " - " + drinkSizes[indexPath.row]
        if (drinkComments[indexPath.row] != "") {
            cell.detailTextLabel?.text = self.drinkComments[indexPath.row]
        } else {
            print("Comment is empty")
        }
        return cell
    }
    
    @IBAction func backToLocationAndTime(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func passData(_ comment: String, _ drinkName: String, _ drinkSize: String, _ drinkPrice:String){
        self.drinkComments.append(comment)
        self.drinks.append(drinkName)
        self.drinkSizes.append(drinkSize)
        self.drinkPrices.append(drinkPrice)
        self.tableView.reloadData();
    }

    
}

