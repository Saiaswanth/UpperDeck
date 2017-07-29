//
//  UDBookedSlots.swift
//  UpperDeck
//
//  Created by Sai on 29/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit

struct UDBookedSlots {
    
    let emailId:String?
    let deviceId:String?
    var bookedSlots: [[String:String]] = [[:]]
}
extension UDBookedSlots{
    
    init(request:[String:AnyObject]) {
        self.bookedSlots.removeAll()
        
        self.emailId = request["EMAIL_ID"] as? String
        self.deviceId = request["DEVICE_ID"] as? String
        let slots = request["BOOKED_SLOTS"] as! [[String : String]]
        
        for eachSlot in slots {
            
            let startTime:String? = eachSlot["st"]
            let endTime:String? = eachSlot["et"]
            let tableNumber:String? = eachSlot["tn"]
            let date:String? = eachSlot["dt"]
            var slotsDictionary:[String:String] = [:]
            slotsDictionary["startTime"] = startTime
            slotsDictionary["endTime"] = endTime
            slotsDictionary["tableNumber"] = tableNumber
            slotsDictionary["date"] = date
            
            self.bookedSlots.append(slotsDictionary)
        }
        
    }
}


