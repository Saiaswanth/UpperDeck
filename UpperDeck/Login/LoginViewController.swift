//
//  ViewController.swift
//  UpperDeck
//
//  Created by Sai on 01/07/17.
//  Copyright © 2017 Sai. All rights reserved.
//

import UIKit
//import Google

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize sign-in
//        var configureError: NSError?
//        GGLContext.sharedInstance().configureWithError(&configureError)
//        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        
        // Uncomment to automatically sign in the user.
        //GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let mainNavigationController = storyboard?.instantiateViewController(withIdentifier: "UDMainNavigationViewController") as! UDMainNavigationViewController
        
        present(mainNavigationController, animated: true, completion: nil)
    }
    
    //GIDSignInDelegate Methods
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if (error == nil) {
//            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let name = user.profile.name
//            let email = user.profile.email
//            let userImageURL = user.profile.imageURL(withDimension: 200)
//            
//            print(userImageURL!)
//            print(userId!)
//            print(idToken!)
//            print(name!)
//            print(email!)
//        }
//        else
//        {
//            print("\(error.localizedDescription)")
//        }
//    }
//    
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
//        
//    }
//
//    //GIDSignInUI delegate methods
//    
//    // Stop the UIActivityIndicatorView animation that was started when the user
//    // pressed the Sign In button
//    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
//        
//        let mainNavigationController = storyboard?.instantiateViewController(withIdentifier: "UDMainNavigationViewController") as! UDMainNavigationViewController
//        
//        present(mainNavigationController, animated: true, completion: nil)
//    }
//    
//    // Present a view that prompts the user to sign in with Google
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        self.present(viewController, animated: true, completion: nil)
//    }
//    
//    // Dismiss the "Sign in with Google" view
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//        self.dismiss(animated: true, completion: nil)
//    }

}

