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
    var facilitiesArray: [[String:String]] = [[:]]
    
    @IBOutlet weak var facilitiesBookingTableView: UITableView!
    @IBOutlet weak var myBookingsView: UIView!
    @IBOutlet weak var bookingActivityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bookingActivityIndicatorView.isHidden = true
        
        facilitiesArray.removeAll()
        createFacilitiesSampleData()
        
        myBookingsView.backgroundColor = UIColor.clear
        myBookingsView.layer.borderWidth = 2;
        myBookingsView.layer.borderColor = UIColor(red: 121/255, green: 85/255, blue: 71/255, alpha: 1.0).cgColor
        myBookingsView.layer.cornerRadius = 5.0
        
        let nib = UINib(nibName: "UDFacilitiesBookingTableViewCell", bundle: nil)
        
        facilitiesBookingTableView.register(nib, forCellReuseIdentifier: reuseIdentifier)

    }
    
    //UITableView delegate and datasource methods
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
        
        cell.facilityName.text = facilitiesArray[indexPath.row]["facilityName"]!
        cell.facilityTodayAvailability.text = facilitiesArray[indexPath.row]["facilityTodayAvailability"]!
        cell.facilityTomorrowAvailability.text = facilitiesArray[indexPath.row]["facilityTomorrowAvailability"]
        cell.facilityImageView.image = UIImage(named: facilitiesArray[indexPath.row]["facilityImageName"]!)
  
        
        cell.selectedIndexPath = indexPath
        cell.delegate = self
        cell.alertDelegate = self
        cell.bookingStatusDelegate = self
        
        if indexPath.row == continueButtonTappedIndex {
            
            cell.bookingTimeView.isHidden = true
            
            if let mobileNumber = UDKeychainService.loadMobileNumber(){
                cell.phoneNumberTextField.text = mobileNumber
            }
            
            if let username = UDKeychainService.loadUsername(){
                cell.nameTextField.text = username
            }
            
            cell.selectedTimings = selectedTimings
            cell.setUpSelectedHoursView()
            cell.bookingConfirmationView.isHidden = false
        }else if indexPath.row == selectedRowIndex{
            
            cell.bookingTimeView.isHidden = false
            cell.bookingConfirmationView.isHidden = true
            
            cell.selectedDaySegmentControl.selectedSegmentIndex = 0
            cell.selectedDaySegmentControl.sendActions(for: UIControlEvents.valueChanged)
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
    
    public func getBookedSlots() {
        
        UDDataManger.shared.getBookedSlots(completion: { response in
            print(response)
        })
    }
    
    func createFacilitiesSampleData() {
    
    
       let dictionaryA = ["facilityName": "Pool Table",
                       "facilityImageName": "pooltable.jpg",
                       "facilityTodayAvailability": "4/12 hours available today",
                       "facilityTomorrowAvailability": "4/12 hours available tomorrow"
       ]
       let dictionaryB = ["facilityName": "Play Station",
                       "facilityImageName": "playstation.png",
                       "facilityTodayAvailability": "4/12 hours available today",
                       "facilityTomorrowAvailability": "4/12 hours available tomorrow"
       ]
       let dictionaryC = ["facilityName": "Foosball",
                          "facilityImageName": "foosball.jpg",
                          "facilityTodayAvailability": "4/12 hours available today",
                          "facilityTomorrowAvailability": "4/12 hours available tomorrow"
       ]
       facilitiesArray.append(dictionaryA)
       facilitiesArray.append(dictionaryB)
       facilitiesArray.append(dictionaryC)
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
            self.view.isUserInteractionEnabled = false
            self.bookingActivityIndicatorView.isHidden = false
            self.bookingActivityIndicatorView.startAnimating()
        }else{
            self.view.isUserInteractionEnabled = true
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
