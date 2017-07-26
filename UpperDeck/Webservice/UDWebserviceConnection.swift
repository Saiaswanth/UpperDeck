//
//  UDWebserviceConnection.swift
//  UpperDeck
//
//  Created by Sai on 15/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit

class UDWebserviceConnection: NSObject,URLSessionDownloadDelegate {

    var downloadUrl:URL!
    
    var homeViewController:UDHomeViewController!
    
    init(_ obj1 : UDHomeViewController)
    {
        self.homeViewController = obj1
    }
    
    //is called once the download is complete
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        //copy downloaded data to your documents directory with same names as source file
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(downloadUrl!.lastPathComponent)
        let dataFromURL = NSData(contentsOf: location)
        dataFromURL?.write(to: destinationUrl, atomically: true)
        
        if session.configuration.identifier == "Menu" {
            
            self.homeViewController.loadDataFromDownloadedMenuText(destinationUrl)
        }else{
            
            self.homeViewController.loadDataFromDownloadedFacilitiesText(destinationUrl)
        }
    
        
        
    }
    
    //this is to track progress
    private func URLSession(session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
    }
    
    // if there is an error during download this will be called
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        if(error != nil)
        {
            //handle the error
            print("Download completed with error: \(error!.localizedDescription)");
        }
    }
    
    //method to be called to download
    func download(url: URL, identifier:String)
    {
        self.downloadUrl = url
        
        //download identifier can be customized. I used the "ulr.absoluteString"
        let sessionConfig = URLSessionConfiguration.background(withIdentifier: identifier)
        let session = Foundation.URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        let task = session.downloadTask(with: url)
        
        task.resume()
    }
}

