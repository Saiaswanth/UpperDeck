//
//  UDFacilitiesBookingTableViewCell.swift
//  UpperDeck
//
//  Created by Sai on 25/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit
import DLRadioButton

protocol ContinueButtonDelegate {
    
    func continueButtonTapped(at indexPath:IndexPath, preferedTimings:[String])
    func cancelButtonTapped(at indexPath:IndexPath)
}

class UDFacilitiesBookingTableViewCell: UITableViewCell,UITextFieldDelegate {
    
    var delegate:ContinueButtonDelegate!
    var selectedIndexPath:IndexPath!
    var selectedTimings:[String] = []
    var selectedDay:String = "Today"

    @IBOutlet weak var selectedDaySegmentControl: UISegmentedControl!
    @IBOutlet weak var bookingTimeView: UIView!
    @IBOutlet weak var bookingConfirmationView: UIView!
    @IBOutlet weak var selectedHoursView: UIView!
    @IBOutlet weak var facilitiesTimeButton: DLRadioButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookingConfirmationView.isHidden = true
        facilitiesTimeButton.isMultipleSelectionEnabled = true
        self.phoneNumberTextField.delegate = self
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
        selectedHoursStackView.backgroundColor = UIColor.red
        
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
        
        switch selectedDaySegmentControl.selectedSegmentIndex {
        case 0:
            selectedDay = selectedDaySegmentControl.titleForSegment(at: 0)!
        case 1:
            selectedDay = selectedDaySegmentControl.titleForSegment(at: 1)!
        default:
            break
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        bookingTimeView.isHidden = true
        bookingConfirmationView.isHidden = false
        self.delegate?.continueButtonTapped(at: selectedIndexPath, preferedTimings: selectedTimings)
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        bookingTimeView.isHidden = false
        bookingConfirmationView.isHidden = true
        self.delegate?.cancelButtonTapped(at: selectedIndexPath)
    }
    
}
