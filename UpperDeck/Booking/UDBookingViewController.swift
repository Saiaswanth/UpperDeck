//
//  UDBookingViewController.swift
//  UpperDeck
//
//  Created by Sai on 01/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit

class UDBookingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UDContinueButtonDelegate,UDAlertDelegate,UDBookingStatusDelegate{

    let reuseIdentifier = "FacilitiesBookingTableCell"
    
    var selectedRowIndex:Int = -1
    var continueButtonTappedIndex:Int = -1
    var cancelButtonTappedIndex:Int = -1
    var selectedTimings:[String] = []
    
    @IBOutlet weak var facilitiesBookingTableView: UITableView!
    @IBOutlet weak var myBookingsView: UIView!
    @IBOutlet weak var bookingActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bookingActivityIndicatorView.isHidden = true
        
        myBookingsView.backgroundColor = UIColor.clear
        myBookingsView.layer.borderWidth = 2;
        myBookingsView.layer.borderColor = UIColor(red: 121/255, green: 85/255, blue: 71/255, alpha: 1.0).cgColor
        myBookingsView.layer.cornerRadius = 5.0
        
        let nib = UINib(nibName: "UDFacilitiesBookingTableViewCell", bundle: nil)
        
        facilitiesBookingTableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
    
//        facilitiesBookingTableView.register(UDFacilitiesBookingTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        
        continueButtonTappedIndex = -1
        cancelButtonTappedIndex = -1
        if selectedRowIndex != indexPath.row{
            
            selectedRowIndex = indexPath.row
        }else{
            selectedRowIndex = -1
        }
        
        self.facilitiesBookingTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        self.facilitiesBookingTableView.beginUpdates()
        self.facilitiesBookingTableView.endUpdates()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! UDFacilitiesBookingTableViewCell
        cell.selectedIndexPath = indexPath
        cell.delegate = self
        cell.alertDelegate = self
        cell.bookingStatusDelegate = self
        
        if indexPath.row == continueButtonTappedIndex {
            
            cell.bookingTimeView.isHidden = true
            cell.selectedTimings = selectedTimings
            cell.setUpSelectedHoursView()
            cell.bookingConfirmationView.isHidden = false
        }else if indexPath.row == selectedRowIndex{
            
            cell.bookingTimeView.isHidden = false
            cell.bookingConfirmationView.isHidden = true
        }else{
            cell.bookingTimeView.isHidden = true
            cell.bookingConfirmationView.isHidden = true
        }
        
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == continueButtonTappedIndex {
            
            return  360
        }
        
        if indexPath.row == selectedRowIndex || indexPath.row == cancelButtonTappedIndex{
            
            return 600
        }
        return 80
    }
    
    //cell delegate method
    
    func continueButtonTapped(at indexPath:IndexPath, preferedTimings:[String]){
        
        continueButtonTappedIndex = indexPath.row
        selectedTimings = preferedTimings
        self.facilitiesBookingTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        self.facilitiesBookingTableView.beginUpdates()
        self.facilitiesBookingTableView.endUpdates()
    }
    
    func cancelButtonTapped(at indexPath:IndexPath){
        
        cancelButtonTappedIndex = indexPath.row
        continueButtonTappedIndex = -1
        self.facilitiesBookingTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        self.facilitiesBookingTableView.beginUpdates()
        self.facilitiesBookingTableView.endUpdates()
    }
    
    func showAlert(with message:String){
        
        let alertController = UIAlertController(title: "UpperDeck", message: message, preferredStyle: .alert)
        let okPressed = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
        })
        
        alertController.addAction(okPressed)
        present(alertController, animated: true, completion: nil)
        
    }
    
    func showActivityIndicator(isVisible:Bool){
        
        if isVisible {
            
            self.bookingActivityIndicatorView.isHidden = false
            self.bookingActivityIndicatorView.startAnimating()
        }else{
            
            self.bookingActivityIndicatorView.stopAnimating()
            self.bookingActivityIndicatorView.isHidden = true
        }
    }
    
    func reloadContents(){
        
        continueButtonTappedIndex = -1
        selectedRowIndex = -1
        cancelButtonTappedIndex = -1
        facilitiesBookingTableView.reloadData()
    }
    
    
}
