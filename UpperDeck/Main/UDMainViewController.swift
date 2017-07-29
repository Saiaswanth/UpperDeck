//
//  UDMainViewController.swift
//  UpperDeck
//
//  Created by Sai on 01/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit

class UDMainViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var bookingButton: UIButton!
    @IBOutlet weak var homeDeliveryButton: UIButton!
    @IBOutlet weak var homeTabSelectionView: UIView!
    @IBOutlet weak var bookingTabSelectionView: UIView!
    @IBOutlet weak var homeDeliveryTabSelectionView: UIView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    var homeViewController:UDHomeViewController!
    var bookingViewController:UDBookingViewController!
    var homeDeliveryViewController:UDHomeDeliveryViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Saving deviceId to keychain
        let deviceUUID: String = (UIDevice.current.identifierForVendor?.uuidString)!
        UDKeychainService.saveDeviceId(deviceId: deviceUUID)
        
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
     
        logoImageView.image = UIImage(named:"logo.jpg")
        homeTabSelected(self.homeButton)
    }

    // Home tab button action
    @IBAction func homeTabSelected(_ sender: Any) {
        
        self.homeTabSelectionView.isHidden = false
        self.bookingTabSelectionView.isHidden = true
        
        if homeViewController == nil {
            
            homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! UDHomeViewController
        }
        
        self.containerScrollView.contentSize = CGSize(width: homeViewController.view.frame.size.width, height: 575)
        print("Content Size:\(self.containerScrollView.contentSize)")
        print ("Width: \(homeViewController.view.frame.size.width) and Height: \(homeViewController.view.frame.size.height)")
        self.containerScrollView.autoresizesSubviews = true
        self.containerScrollView.isScrollEnabled = true
        self.containerScrollView.addSubview(homeViewController.view)
        
    }
    
    //Booking tab button action
    @IBAction func bookingTabSelected(_ sender: Any) {
        
        self.homeTabSelectionView.isHidden = true
        self.bookingTabSelectionView.isHidden = false
        
        if bookingViewController == nil{
            
            bookingViewController = storyboard?.instantiateViewController(withIdentifier: "BookingViewController") as! UDBookingViewController
        }
        bookingViewController.getBookedSlots()
        self.containerScrollView.contentSize = CGSize(width: bookingViewController.view.frame.size.width, height: bookingViewController.view.frame.size.height)
        self.containerScrollView.addSubview(bookingViewController.view)
    }
    
    //Home delivery tab button action
    @IBAction func homeDeliveryTabSelected(_ sender: Any) {
        
        self.homeTabSelectionView.isHidden = true
        self.bookingTabSelectionView.isHidden = true
        self.homeDeliveryTabSelectionView.isHidden = false
        
        if homeDeliveryViewController == nil{
            
            homeDeliveryViewController = storyboard?.instantiateViewController(withIdentifier: "HomeDeliveryViewController") as! UDHomeDeliveryViewController
        }
        
        self.containerScrollView.contentSize = CGSize(width: homeDeliveryViewController.view.frame.size.width, height: homeDeliveryViewController.view.frame.size.height - 30)
        self.containerScrollView.addSubview(homeDeliveryViewController.view)
    }
}
