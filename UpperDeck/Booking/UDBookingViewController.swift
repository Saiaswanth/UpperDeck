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
    @IBOutlet weak var myBookingsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var myBookingsDetailsView: UIView!
    
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
            
            var bookedSlotsArray:[[String:String]] = [[:]]
            bookedSlotsArray.removeAll()
            
            for bookedSlot in response.bookedSlots{
                
                var bookedSlotsDict:[String:String] = [:]
                bookedSlotsDict.removeAll()
                
                // For getting facility name
                let tableNumber:String = bookedSlot["tableNumber"]!
                var facilityName:String
                switch tableNumber{
                case "1":
                    facilityName = "Pool Table"
                    break
                case "2":
                    facilityName = "Play Station"
                    break
                case "3":
                    facilityName = "Foosball"
                    break
                default:
                    facilityName = ""
                    break
                }
                bookedSlotsDict["facilityName"] = facilityName
                
                //For getting date
                let myDateString = bookedSlot["date"]!
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "ddMMyy"
                let myDate = dateFormatter.date(from: myDateString)!
                
                dateFormatter.dateFormat = "dd-MM-yy"
                let formattedDateString = dateFormatter.string(from: myDate)
                
                bookedSlotsDict["date"] = formattedDateString
                
                // For getting time slot
                var startTime = bookedSlot["startTime"]!
                var endTime = bookedSlot["endTime"]!
                
                let startTimeIndex = startTime.index(startTime.startIndex, offsetBy: 2)
                startTime = startTime.substring(to: startTimeIndex) + ":" + "00"

                let sessionType = endTime.characters.last!
                
                let endTimeIndex = endTime.index(endTime.startIndex, offsetBy: 2)
                endTime = endTime.substring(to: endTimeIndex) + ":" + "00"
                
                // Converting individual start time and end time to 00:00 - 01:00 PM format
                let formattedTime = startTime + "-" + endTime + " "
                bookedSlotsDict["time"] = formattedTime + String(describing: sessionType) + "M"
                
                bookedSlotsArray.append(bookedSlotsDict)
            }
            
            self.myBookingsViewHeightConstraint.constant = CGFloat(bookedSlotsArray.count * 25 + 60)
            
            let subViews = self.myBookingsDetailsView.subviews
            for subview in subViews{
                subview.removeFromSuperview()
            }
            
            //Stack View
            let bookedSlotsStackView = UIStackView()
            bookedSlotsStackView.axis  = UILayoutConstraintAxis.vertical
            bookedSlotsStackView.distribution  = UIStackViewDistribution.equalSpacing
            bookedSlotsStackView.alignment = UIStackViewAlignment.center
            bookedSlotsStackView.spacing   = 5.0
            
            
            for individualSlot in bookedSlotsArray{
                
                let slotText = individualSlot["facilityName"]! + "    " + individualSlot["time"]! + "\t\t" + individualSlot["date"]!
                
                let bookedSlotLabel = UILabel()
                bookedSlotLabel.widthAnchor.constraint(equalToConstant: self.myBookingsDetailsView.frame.width).isActive = true
                bookedSlotLabel.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
                bookedSlotLabel.text  = slotText
                bookedSlotLabel.textAlignment = .left
                bookedSlotLabel.textColor=UIColor.black
                bookedSlotLabel.font=UIFont.systemFont(ofSize: 14)
                bookedSlotsStackView.addArrangedSubview(bookedSlotLabel)
            }
            
            bookedSlotsStackView.translatesAutoresizingMaskIntoConstraints = false
            
            self.myBookingsDetailsView.addSubview(bookedSlotsStackView)
            
            //Constraints
            bookedSlotsStackView.centerXAnchor.constraint(equalTo: self.myBookingsDetailsView.centerXAnchor).isActive = true
            bookedSlotsStackView.centerYAnchor.constraint(equalTo: self.myBookingsDetailsView.centerYAnchor).isActive = true
            
        })
    }
    
    func createFacilitiesSampleData() {
    
    
       let dictionaryA = ["facilityName": "Pool Table",
                       "facilityImageName": "pooltable.jpg",
                       "facilityTodayAvailability": "12/12 hours available today",
                       "facilityTomorrowAvailability": "12/12 hours available tomorrow"
       ]
       let dictionaryB = ["facilityName": "Play Station",
                       "facilityImageName": "playstation.png",
                       "facilityTodayAvailability": "12/12 hours available today",
                       "facilityTomorrowAvailability": "12/12 hours available tomorrow"
       ]
       let dictionaryC = ["facilityName": "Foosball",
                          "facilityImageName": "foosball.jpg",
                          "facilityTodayAvailability": "12/12 hours available today",
                          "facilityTomorrowAvailability": "12/12 hours available tomorrow"
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
        
        getBookedSlots()
        facilitiesBookingTableView.reloadData()
    }
    
    
}
