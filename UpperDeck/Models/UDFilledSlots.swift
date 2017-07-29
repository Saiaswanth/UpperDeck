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
            
            let startTime:String? = request["st"]
            let endTime:String? = request["et"]
            var slotsDictionary:[String:String] = [:]
            slotsDictionary["startTime"] = startTime
            slotsDictionary["endTime"] = endTime
            
            self.filledSlots.append(slotsDictionary)
        }
    }
}
