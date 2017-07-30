//
//  UDFilledSlots.swift
//  UpperDeck
//
//  Created by Sai on 29/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit

//class UDFilledSlots:NSObject{
//    
//    public var filledSlots: [[String:String]] = [[:]]
//    
//    override init() {
//        
//        super.init()
//    }
//}

struct UDFilledSlots {
    
    var filledSlots: [[String:String]] = [[:]]
}

extension UDFilledSlots{
    
    init(requests:[[String:String]]) {
        
        self.filledSlots.removeAll()
        for request in requests {
            
            var slotsDictionary:[String:String] = [:]
            if let startTime = request["st"] {
                
                slotsDictionary["startTime"] = startTime
            }
            if let endTime =  request["et"]{
                
                slotsDictionary["endTime"] = endTime
            }
            
            self.filledSlots.append(slotsDictionary)
        }
    }
}
