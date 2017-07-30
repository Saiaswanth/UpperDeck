//
//  UDFacilitiesBookingTableViewCell.swift
//  UpperDeck
//
//  Created by Sai on 25/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit
import DLRadioButton

protocol UDContinueButtonDelegate {
    
    func continueButtonTapped(at indexPath:IndexPath, preferedTimings:[String])
    func cancelButtonTapped(at indexPath:IndexPath)
}

protocol UDAlertDelegate {
    
    func showAlert(with message:String)
    func showActivityIndicator(isVisible:Bool)
}

protocol UDBookingStatusDelegate {
    
    func reloadContents()
}

class UDFacilitiesBookingTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    var delegate:UDContinueButtonDelegate!
    var alertDelegate:UDAlertDelegate!
    var bookingStatusDelegate:UDBookingStatusDelegate!
    
    var selectedIndexPath:IndexPath!
    var selectedTimings:[String] = []
    var timingButtons:[DLRadioButton]=[]
    var selectedDay:String = "Today"
    

    @IBOutlet weak var selectedDaySegmentControl: UISegmentedControl!
    @IBOutlet weak var bookingTimeView: UIView!
    @IBOutlet weak var bookingConfirmationView: UIView!
    @IBOutlet weak var selectedHoursView: UIView!
    @IBOutlet weak var facilitiesTimeButton: DLRadioButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var hidingView: UIView!
    
    @IBOutlet weak var facilityImageView: UIImageView!
    @IBOutlet weak var facilityName: UILabel!
    @IBOutlet weak var facilityTomorrowAvailability: UILabel!
    @IBOutlet weak var facilityTodayAvailability: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookingConfirmationView.isHidden = true
        facilitiesTimeButton.isMultipleSelectionEnabled = true
        hidingView.isHidden = true
        
        self.phoneNumberTextField.delegate = self
        self.nameTextField.delegate = self
        
        //Adding timings buttons in an array
        timingButtons.append(self.facilitiesTimeButton)
        for button in self.facilitiesTimeButton.otherButtons {
            
            timingButtons.append(button)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
     public func setUpSelectedHoursView(){
        
        
        self.selectedHoursView.layer.borderWidth = 2.0
        self.selectedHoursView.layer.borderColor = UIColor(red: 121/255, green: 85/255, blue: 71/255, alpha: 1.0).cgColor
        self.selectedHoursView.layer.cornerRadius = 5.0
        
        //Stack View
        let selectedHoursStackView = UIStackView()
        selectedHoursStackView.axis  = UILayoutConstraintAxis.vertical
        selectedHoursStackView.distribution  = UIStackViewDistribution.equalSpacing
        selectedHoursStackView.alignment = UIStackViewAlignment.center
        selectedHoursStackView.spacing   = 5.0
        
        //Text Label
        let selectedHoursLabel = UILabel()
        selectedHoursLabel.widthAnchor.constraint(equalToConstant: self.selectedHoursView.frame.width).isActive = true
        selectedHoursLabel.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
        selectedHoursLabel.text  = "Selected Hours"
        selectedHoursLabel.textAlignment = .center
        selectedHoursLabel.textColor=UIColor.darkGray
        selectedHoursLabel.font=UIFont.systemFont(ofSize: 14)
        
        //Adding labels to stackview
        selectedHoursStackView.addArrangedSubview(selectedHoursLabel)
        
        for selectedTime in selectedTimings {
            
            let selectedTimeLabel = UILabel()
            selectedTimeLabel.widthAnchor.constraint(equalToConstant: self.selectedHoursView.frame.width).isActive = true
            selectedTimeLabel.heightAnchor.constraint(equalToConstant: 21.0).isActive = true
            selectedTimeLabel.text  = selectedTime
            selectedTimeLabel.textAlignment = .center
            selectedTimeLabel.textColor=UIColor.black
            selectedTimeLabel.font=UIFont.systemFont(ofSize: 16)
            selectedHoursStackView.addArrangedSubview(selectedTimeLabel)
        }
        
        selectedHoursStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.selectedHoursView.addSubview(selectedHoursStackView)
        
        //Constraints
        selectedHoursStackView.centerXAnchor.constraint(equalTo: self.selectedHoursView.centerXAnchor).isActive = true
        selectedHoursStackView.centerYAnchor.constraint(equalTo: self.selectedHoursView.centerYAnchor).isActive = true
        
    }
    
    public func getFilledSlotsOfRequestedDate(requestedDate:String, tableNumber:String){
        
        self.alertDelegate?.showActivityIndicator(isVisible: true)
        self.hidingView.isHidden = false
        
        UDDataManger.shared.getFilledSlotsForDay(date: requestedDate, tableNumber: tableNumber, completion: { response in
            
            self.alertDelegate?.showActivityIndicator(isVisible: false)
            self.hidingView.isHidden = true
            print(response)
           
            for individualSlot in response.filledSlots{
                
                for individualTimingButton in self.timingButtons{
                    
                    let buttonText = individualTimingButton.titleLabel?.text
                    let contents = buttonText?.components(separatedBy: " ")
                    let firstChar = contents?[3][(contents?[3].index((contents?[3].startIndex)!, offsetBy: 0))!]
                    
                    // To get start time in "06P" or "11A" format
                    let startTimeComponents = contents?[0].components(separatedBy: ":")
                    let startTime = (startTimeComponents?[0])! + String(firstChar!)
                    
                    if individualSlot["startTime"] == startTime{
                        
                        individualTimingButton.isEnabled = false
                        individualTimingButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
                    }
                    
                }
            }
        })
        
        
    }
    
    func enableRemainingTimings(){
        
    
        let date = NSDate() // return current time and date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // for specifying the change to format hour:minute am/pm.
        let timeInString = dateFormatter.string(from: date as Date) // provide current time in string formatted in 06:35 PM if current time is 18:35
        let timeContents = timeInString.components(separatedBy: " ")
        let timeComponents = timeContents[0].components(separatedBy:":")
        
        var presentTimeInHours = Int(timeComponents[0])
        
        if presentTimeInHours == 12 {
            presentTimeInHours = 00
        }
        
        var buttonTag:Int!
        
        //For getting the button tag of current time
        for individualTimingButton in self.timingButtons{
            
            let buttonText = individualTimingButton.titleLabel?.text
            let contents = buttonText?.components(separatedBy: " ")
            
            let timeComponents = contents?[0].components(separatedBy: ":")
            let endTimeInButtonText = Int((timeComponents?[0])!)
            
            var finalTimeInHours = presentTimeInHours! + 1
            
            if finalTimeInHours == 12{
                finalTimeInHours = 00
            }
            
            if endTimeInButtonText! == finalTimeInHours{
                
                buttonTag = individualTimingButton.tag
                
            }
            
        }
        
        //For disabling the buttons
        for individualTimingButton in self.timingButtons{
            
            if individualTimingButton.tag <= buttonTag {
                
                individualTimingButton.isEnabled = false
                individualTimingButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
            }else{
                individualTimingButton.isEnabled = true
                individualTimingButton.setTitleColor(UIColor(red: 121/255, green: 85/255, blue: 71/255, alpha: 1.0), for: UIControlState.normal)
            }
        }
        
    }
    
    //UITextField Delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    @IBAction func facilitiesTimeSelectionButtonTapped(_ radioButton : DLRadioButton) {
        
        selectedTimings.removeAll()
        if (radioButton.isMultipleSelectionEnabled) {
            for button in radioButton.selectedButtons() {
                print(String(format: "%@ is selected.\n", button.titleLabel!.text!));
                let selectedTime = selectedDay + " " + button.titleLabel!.text!
                selectedTimings.append(selectedTime)
                
            }
        }
    }

    @IBAction func daySegmentControlAction(_ sender: UISegmentedControl) {
        
        var requestedDate:String!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyy"
        let currentDate = Date()
        
        //For reseting the color of all buttons
        for individualTimingButton in self.timingButtons{
            
            individualTimingButton.isEnabled = true
            individualTimingButton.setTitleColor(UIColor(red: 121/255, green: 85/255, blue: 71/255, alpha: 1.0), for: UIControlState.normal)
            if individualTimingButton.isSelected {
                
                individualTimingButton.isSelected = false
            }
        }
        
        self.enableRemainingTimings()
        
        switch selectedDaySegmentControl.selectedSegmentIndex {
        case 0:
            selectedDay = selectedDaySegmentControl.titleForSegment(at: 0)!
            requestedDate = dateFormatter.string(from: currentDate)
            
        case 1:
            selectedDay = selectedDaySegmentControl.titleForSegment(at: 1)!
            let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            requestedDate = dateFormatter.string(from: tomorrowDate!)
            
        default:
            break
        }
        getFilledSlotsOfRequestedDate(requestedDate: requestedDate, tableNumber: String(selectedIndexPath.row + 1))
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        if selectedTimings.count < 1 {
            
            self.alertDelegate?.showAlert(with: "Please select atleast an hour")
            return
        }else if selectedTimings.count > 3{
            
            self.alertDelegate?.showAlert(with: "You can book maximum of 3 hours")
            return
        }
        
        bookingTimeView.isHidden = true
        bookingConfirmationView.isHidden = false
        self.delegate?.continueButtonTapped(at: selectedIndexPath, preferedTimings: selectedTimings)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        if (self.nameTextField.text?.isEmpty)! ||  (self.phoneNumberTextField.text?.isEmpty)!{
            
            self.alertDelegate?.showAlert(with: "Please Enter Name and Mobile Number")
            return
        }
        
        //Saving user phone number and username to keychain
        if !(self.nameTextField.text?.isEmpty)! {
            UDKeychainService.saveUsername(username: self.nameTextField.text!)
        }
        
        if !(self.phoneNumberTextField.text?.isEmpty)! {
            UDKeychainService.saveMobileNumber(number: self.phoneNumberTextField.text!)
        }
        
        //Creating request dictionary
        var facilityRequestDict:[String:String] = ["userName":self.nameTextField.text!,
                                   "phoneNumber":self.phoneNumberTextField.text!
        ]
        
        for selectedTime in selectedTimings {
            
            var requestedDate: String = ""
            
            let contents = selectedTime.components(separatedBy: " ")
            let firstChar = contents[4][contents[4].index(contents[4].startIndex, offsetBy: 0)]
            
            // To get start time in "06P" or "11A" format
            let startTimeComponents = contents[1].components(separatedBy: ":")
            let startTime = startTimeComponents[0] + String(firstChar)
            
            // To get end time in "06P" or "11A" format
            let endTimeComponents = contents[3].components(separatedBy: ":")
            let endTime = endTimeComponents[0] + String(firstChar)
            
            // To get the date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyy"
            let currentDate = Date()
            
            if contents[0] == "Today" {
                
                requestedDate = dateFormatter.string(from: currentDate)
            }else{
                
                let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
                requestedDate = dateFormatter.string(from: tomorrowDate!)
            }
            
            facilityRequestDict["startTime"] = startTime
            facilityRequestDict["endTime"] = endTime
            facilityRequestDict["requestedStatus"] = "REQUESTED"
            facilityRequestDict["date"] = requestedDate
            facilityRequestDict["tableNumber"] = String(selectedIndexPath.row + 1)
            facilityRequestDict["deviceId"] = UDKeychainService.loadDeviceId()
        }
        
        self.alertDelegate?.showActivityIndicator(isVisible: true)
        
        let udFacilityRequest:UDFacilityRequest = UDFacilityRequest.init(request: facilityRequestDict)
        UDDataManger.shared.requestFacilities(requestData: udFacilityRequest, completion: {response in
            
            self.selectedTimings.removeAll()
            self.alertDelegate?.showActivityIndicator(isVisible: false)
            print (response)
            
            if response["result"] as? Int == 1{
                
                self.alertDelegate?.showAlert(with: "Booking Successful")
            }else{
                
                self.alertDelegate?.showAlert(with: "An Unknown Error Occurred. Please Try Again")
            }
            
            self.bookingStatusDelegate?.reloadContents()
        })
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        bookingTimeView.isHidden = false
        bookingConfirmationView.isHidden = true
        
        let subViews = self.selectedHoursView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
        }
        
        self.delegate?.cancelButtonTapped(at: selectedIndexPath)
    }
    
}
