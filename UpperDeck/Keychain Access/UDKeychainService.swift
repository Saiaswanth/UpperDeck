//
//  UDKeychainService.swift
//  UpperDeck
//
//  Created by Sai on 29/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"


/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

let mobileNumberKey = "KeyForMobileNumber"
let usernameKey = "KeyForUsername"
let deviceIdKey = "KeyForDeviceId"
let emailIdKey = "KeyForEmailId"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class UDKeychainService: NSObject {
    
    /**
     * Exposed methods to perform save and load queries.
     */
    
    public class func saveMobileNumber(number:String){
        self.save(service: mobileNumberKey, data: number)
    }
    
    public class func saveUsername(username:String){
        self.save(service: usernameKey, data: username)
    }
    
    public class func saveDeviceId(deviceId:String){
        self.save(service: deviceIdKey, data: deviceId)
    }
    
    public class func saveUserEmailId(emailId:String){
        self.save(service: emailIdKey, data: emailId)
    }
    
    public class func loadMobileNumber() -> String? {
        return self.load(service: mobileNumberKey)
    }
    
    public class func loadUsername() -> String? {
        return self.load(service: usernameKey)
    }
    
    public class func loadDeviceId() -> String?{
        return self.load(service: deviceIdKey)
    }
    
    public class func loadEmailId() -> String?{
        return self.load(service: emailIdKey)
    }
    
    /**
     * Internal methods for querying the keychain.
     */
    
    private class func save(service: String, data: String) {
        let dataFromString: NSData = data.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false)! as NSData
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private class func load(service: String) -> String? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = String(data: (((retrievedData as Data) as Data) as Data) as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
}
