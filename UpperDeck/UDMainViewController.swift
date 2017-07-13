//
//  UDMainViewController.swift
//  UpperDeck
//
//  Created by Sai on 01/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit

class UDMainViewController: UIViewController {

    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var bookingButton: UIButton!
    @IBOutlet weak var homeDeliveryButton: UIButton!
    @IBOutlet weak var homeTabSelectionView: UIView!
    @IBOutlet weak var bookingTabSelectionView: UIView!
    @IBOutlet weak var homeDeliveryTabSelectionView: UIView!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
     
     homeTabSelected(self.homeButton)
    }

    // Home tab button action
    @IBAction func homeTabSelected(_ sender: Any) {
        
        self.homeTabSelectionView.isHidden = false
        self.bookingTabSelectionView.isHidden = true
        self.homeDeliveryTabSelectionView.isHidden = true
        
        let homeViewController = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! UDHomeViewController
        self.containerScrollView.contentSize = CGSize(width: homeViewController.view.frame.size.width, height: homeViewController.view.frame.size.height)
        
        self.containerScrollView.addSubview(homeViewController.view)
        
    }
    
    //Booking tab button action
    @IBAction func bookingTabSelected(_ sender: Any) {
        
        self.homeTabSelectionView.isHidden = true
        self.bookingTabSelectionView.isHidden = false
        self.homeDeliveryTabSelectionView.isHidden = true
        
        let bookingViewController = storyboard?.instantiateViewController(withIdentifier: "BookingViewController") as! UDBookingViewController
        
        self.containerScrollView.addSubview(bookingViewController.view)
    }
    
    //Home delivery tab button action
    @IBAction func homeDeliveryTabSelected(_ sender: Any) {
        
        self.homeTabSelectionView.isHidden = true
        self.bookingTabSelectionView.isHidden = true
        self.homeDeliveryTabSelectionView.isHidden = false
        
        let homeDeliveryViewController = storyboard?.instantiateViewController(withIdentifier: "HomeDeliveryViewController") as! UDHomeDeliveryViewController
        
        self.containerScrollView.addSubview(homeDeliveryViewController.view)
    }
}
