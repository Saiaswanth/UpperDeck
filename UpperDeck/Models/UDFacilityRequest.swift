//
//  UDFacilityRequest.swift
//  UpperDeck
//
//  Created by Sai on 27/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit

struct UDFacilityRequest {
    
    let userName:String?
    let phoneNumber:String?
    let tableNumber:String?
    let startTime:String?
    let endTime:String?
    let requestedStatus:String?
    let date:String?
    let deviceId:String?
}

extension UDFacilityRequest{
    
    init(request:[String:String]) {
        
        self.userName = request["userName"]
        self.phoneNumber = request["phoneNumber"]
        self.tableNumber = request["tableNumber"]
        self.startTime = request["startTime"]
        self.endTime =  request["endTime"]
        self.requestedStatus = request["requestedStatus"]
        self.date = request["date"]
        self.deviceId = request["deviceId"]
        
    }
}
