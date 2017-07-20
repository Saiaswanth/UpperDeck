//
//  UDHomeViewController.swift
//  UpperDeck
//
//  Created by Sai on 01/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit
import SDWebImage

class UDHomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    // Constants
    let reuseIdentifier = "CellIdentifier"
    let contactNumber = 9567775545
    let requiredLatitude = 22.9783
    let requiredLongitude = 72.6002
    
    let menuBaseUrl = "http://www.upperdeck.in/ud/menu_main/"
    let facilitiesBaseUrl = "http://www.upperdeck.in/ud/facilities/"
    let menuDataUrl = "http://www.upperdeck.in/ud/menu_main/menu_items.txt"
    let facilitiesDataUrl = "http://www.upperdeck.in/ud/facilities/facilities.txt"
    
    var itemArray: [[String:String]] = [[ : ]]
    var facilitiesArray: [[String:String]] = [[:]]
    
    
    // Outlets
    @IBOutlet weak var facilitiesCollectionActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var menuCollectionActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var facilitiesCollectionView: UICollectionView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    //Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemArray.removeAll()
        facilitiesArray.removeAll()
        
        let menuUrl = URL(string: menuDataUrl)
        let facilitiesUrl = URL(string: facilitiesDataUrl)
        
        facilitiesCollectionActivityIndicatorView.startAnimating()
        menuCollectionActivityIndicatorView.startAnimating()
        
        UDWebserviceConnection(self).download(url: menuUrl!, identifier: "Menu")
        UDWebserviceConnection(self).download(url: facilitiesUrl!, identifier: "Facilities")
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    public func loadDataFromDownloadedMenuText(_ filePath:URL){
        
        print("Downloaded file path is : \(filePath)")
        
        do {
            let mytext = try String(contentsOf: filePath)
            print("My text is \(mytext)")
            
            let contents = mytext.components(separatedBy: "\n")
            self.itemArray.removeAll()
            for individualContent in contents {
                
                var dict:Dictionary<String,String> = [:]
                
                let itemDetails = individualContent.components(separatedBy: "\t")
                if itemDetails.count > 2 {
                    
                    dict["itemName"] = itemDetails[0]
                    dict["itemImageName"] = itemDetails[1]
                    dict["itemDescription"] = itemDetails[2]
                    
                    if dict.count > 0 {
                        self.itemArray.append(dict)
                    }
                }
            }
            
        } catch {
            print("error loading contents of:", filePath, error)
        }
        
        self.menuCollectionView.reloadData()
        menuCollectionActivityIndicatorView.stopAnimating()
        menuCollectionActivityIndicatorView.isHidden = true
        
    }
    
    public func loadDataFromDownloadedFacilitiesText(_ filePath:URL){
        
        print("Downloaded file path is : \(filePath)")
        
        do {
            let mytext = try String(contentsOf: filePath)
            print("My text is \(mytext)")
            
            let contents = mytext.components(separatedBy: "\n")
            self.facilitiesArray.removeAll()
            for individualContent in contents {
                
                var dict:Dictionary<String,String> = [:]
                
                let itemDetails = individualContent.components(separatedBy: "\t")
                if itemDetails.count > 2 {
                    
                    dict["itemName"] = itemDetails[0]
                    dict["itemImageName"] = itemDetails[1]
                    dict["itemDescription"] = itemDetails[2]
                    
                    if dict.count > 0 {
                        self.facilitiesArray.append(dict)
                    }
                }
            }
            
        } catch {
            print("error loading contents of:", filePath, error)
        }
        
        self.facilitiesCollectionView.reloadData()
        self.facilitiesCollectionActivityIndicatorView.stopAnimating()
        self.facilitiesCollectionActivityIndicatorView.isHidden = true
        
    }
    
    
    func createFacilitiesSampleData() {
        
        var dictionaryA = [
            "itemName": "Pool Table",
            "itemImageName": "pooltable.jpg",
            "itemDescription": "Binge on fun with Pool Table while you tickle your taste buds with our delicacies"
        ]
        var dictionaryB = [
            "itemName": "Foosball",
            "itemImageName": "foosball.jpg",
            "itemDescription": "Enjoy the fun with Foosball while you spend some relaxing time with your friends"
        ]
        var dictionaryC = [
            "itemName": "Play Station",
            "itemImageName": "playstation.png",
            "itemDescription": "Enjoy gaming with Play Station."
        ]
        facilitiesArray.append(dictionaryA)
        facilitiesArray.append(dictionaryB)
        facilitiesArray.append(dictionaryC)
    }
 
    //IBAction methods
    
    // Map button action
    @IBAction func mapButtonTapped(_ sender: Any) {
    
        //Launches the google maps otherwise default maps
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        {
            // use bellow line for specific source location
            //let urlString = "http://maps.google.com/?saddr=\(sourceLocation.latitude),\(sourceLocation.longitude)&daddr=\(destinationLocation.latitude),\(destinationLocation.longitude)&directionsmode=driving"
            
            let urlString = "http://maps.google.com/?daddr=\(requiredLatitude),\(requiredLongitude)&directionsmode=driving"
            
            UIApplication.shared.open(URL(string: urlString)!, options:[:], completionHandler: nil)
        }
        else
        {
            
//            //let urlString = "http://maps.apple.com/maps?saddr=\(sourceLocation.latitude),\(sourceLocation.longitude)&daddr=\(destinationLocation.latitude),\(destinationLocation.longitude)&dirflg=d"
            
            let urlString = "http://maps.apple.com/maps?daddr=\(requiredLatitude),\(requiredLongitude)&dirflg=d"
            
            UIApplication.shared.open(URL(string:urlString)!, options: [:], completionHandler: nil)
        }
        
    }
    
    @IBAction func callButtonTapped(_ sender: Any) {
        
        if let phoneCallURL:URL = URL(string: "tel:\(contactNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                let alertController = UIAlertController(title: "UpperDeck", message: "Are you sure you want to call \n\(self.contactNumber)?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                    UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
                })
                let noPressed = UIAlertAction(title: "No", style: .default, handler: { (action) in
                    
                })
                alertController.addAction(yesPressed)
                alertController.addAction(noPressed)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    //Collection View delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var itemCount = 0;
        if collectionView == menuCollectionView {
            
            itemCount = itemArray.count
        }
        if collectionView == facilitiesCollectionView {
            
            itemCount = facilitiesArray.count
        }
        return itemCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:reuseIdentifier, for: indexPath as IndexPath) as! UDDishCollectionViewCell
        
        if collectionView == menuCollectionView {
            
            cell.backgroundColor = UIColor.lightGray
            
            if itemArray.count > 0 {
                
                let imageUrl = menuBaseUrl + itemArray[indexPath.row]["itemImageName"]!
                let itemName = itemArray[indexPath.row]["itemName"]
                let itemDescription = itemArray[indexPath.row]["itemDescription"]
                cell.dishImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
                cell.itemName.text = itemName
            }
            
        }
        if collectionView == facilitiesCollectionView {
            
            cell.dishImageView.backgroundColor = UIColor.darkGray
            if facilitiesArray.count > 0 {
                
                let imageUrl = facilitiesBaseUrl + facilitiesArray[indexPath.row]["itemImageName"]!
                let itemName = facilitiesArray[indexPath.row]["itemName"]
                let itemDescription = facilitiesArray[indexPath.row]["itemDescription"]
                cell.dishImageView.image = UIImage(named: facilitiesArray[indexPath.row]["itemImageName"]!)
//                cell.dishImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: nil)
                cell.itemName.text = ""
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
