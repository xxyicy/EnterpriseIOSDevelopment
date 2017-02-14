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
    func passDrinkData(_ comment: String, _ drinkName: String, _ drinkSize: String, _ drinkPrice: String)
    func passSnackData(_ snackName: String, _ snackPrice: String)
}

class OrderDetailViewController : UIViewController, UITableViewDataSource,UITableViewDelegate, passOrderDetail{
    @IBOutlet var AddDrinkButton: UIImageView!
    @IBOutlet var AddSnackButton: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var drinks: [String] = []
    var drinkComments:[String] = []
    var drinkSizes: [String] = []
    var drinkPrices: [String] = []
    var snacks: [String] = []
    var snackPrices: [String] = []
    
    
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
        nextViewController.snacks = self.snacks
        nextViewController.snackPrices = self.snackPrices
        
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
        modal.VCRef = self
        modal.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        modal.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(modal, animated: true)
    }
    
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let temp = drinks.count + snacks.count
        return temp
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell =
            tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath)
        if (indexPath.row >= drinks.count) {
            let tempIndex = indexPath.row - drinks.count
            cell.textLabel?.text = snacks[tempIndex]
            cell.detailTextLabel?.text = ""
        } else {
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
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if (indexPath.row >= self.drinks.count){
                self.snacks.remove(at: indexPath.row-self.drinks.count)
                self.snackPrices.remove(at: indexPath.row-self.drinks.count)
            }else{
                self.drinkComments.remove(at: indexPath.row)
                self.drinks.remove(at: indexPath.row)
                self.drinkSizes.remove(at: indexPath.row)
                self.drinkPrices.remove(at: indexPath.row)
            }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func backToLocationAndTime(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func passDrinkData(_ comment: String, _ drinkName: String, _ drinkSize: String, _ drinkPrice:String){
        self.drinkComments.append(comment)
        self.drinks.append(drinkName)
        self.drinkSizes.append(drinkSize)
        self.drinkPrices.append(drinkPrice)
        self.tableView.reloadData()
    }
    
    func passSnackData(_ snackName: String, _ snackPrice: String) {
        self.snacks.append(snackName)
        self.snackPrices.append(snackPrice)
        self.tableView.reloadData()
    }
    
    
}

