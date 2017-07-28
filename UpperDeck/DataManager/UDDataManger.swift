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

class UDDataManger: NSObject {
    
    var homeViewController:UDHomeViewController = UDHomeViewController()
    
    class var shared:UDDataManger{
        return _sharedInstance
    }
    
    func  requestFacilities(requestData:UDFacilityRequest,  completion: @escaping (_ success: [String : AnyObject]) -> Void ) {
        
        let paramDictionary:[String:String] = ["un":requestData.userName!,
                               "ph":requestData.phoneNumber!,
                               "tn":requestData.tableNumber!,
                               "st":requestData.startTime!,
                               "et":requestData.endTime!,
                               "ss":requestData.requestedStatus!,
                               "dt":requestData.date!]
        
        
        UDWebserviceConnection(homeViewController).requestFacilities(url: facilityRequestUrl, params: paramDictionary, completion: {response in
            
            print (response)
            completion(response)
        })
    }

}
