//
//  UDDataManger.swift
//  UpperDeck
//
//  Created by Sai on 27/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit

private let _sharedInstance = UDDataManger()

let facilityRequestUrl = "http://www.upperdeck.in/api/insert_table_request/"
let getFilledSlotsUrl = "http://upperdeck.in/api/getFilledSlotsOfDay/"

class UDDataManger: NSObject {
    
    var homeViewController:UDHomeViewController = UDHomeViewController()
    
    class var shared:UDDataManger{
        return _sharedInstance
    }
    
    func  requestFacilities(requestData:UDFacilityRequest,  completion: @escaping (_ success: [String:AnyObject]) -> Void ) {
        
        var responseDict:[String:AnyObject] = [:]
        let paramDictionary:[String:String] = ["un":requestData.userName!,
                                               "pn":requestData.phoneNumber!,
                                               "tn":requestData.tableNumber!,
                                               "st":requestData.startTime!,
                                               "et":requestData.endTime!,
                                               "ss":requestData.requestedStatus!,
                                               "dt":requestData.date!,
                                               "deviceid":requestData.deviceId!]
        
        
        UDWebserviceConnection(homeViewController).getDetails(url: facilityRequestUrl, params: paramDictionary, completion: {response in
            
            responseDict["result"] = response.object(forKey: "result") as AnyObject
            responseDict["status"] = response.object(forKey: "status") as AnyObject
            
            print (response)
            completion(responseDict)
        })
    }
    
    func  getFilledSlotsForDay(date:String, tableNumber:String, completion: @escaping (_ success: UDFilledSlots) -> Void ) {
        
        
        let paramDictionary:[String:String] = ["datestr":date,
                                               "tno":tableNumber]
        
        
        UDWebserviceConnection(homeViewController).getDetails(url: getFilledSlotsUrl, params: paramDictionary, completion: {response in
            
            print ("Get filled slots response:\(response)")
            
            let filledSlots:UDFilledSlots = UDFilledSlots.init(requests:(response.object(forKey: "table_requests") as AnyObject) as! [[String : String]] )
            
            print (filledSlots)
            completion(filledSlots)
        })
    }

}
