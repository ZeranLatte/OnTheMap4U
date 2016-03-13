//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by ZZZZeran on 11/4/15.
//  Copyright © 2015 Z Latte. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    var session: NSURLSession!
    
    

    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    
    // MARK: Actions

    @IBAction func facebookSignIn(sender: AnyObject) {
        
        
    }
    
    
    
    @IBAction func loginAction(sender: AnyObject) {
        
        if let myEmail = emailTF.text, let myPassword = passwordTF.text {
            NetworkManager.sharedInstance().authenticateToUdacity(myEmail, password: myPassword, hostVC: self) { (success, error) in
                if success {
                    self.completeLogin()
                } else {
                    if error.debugDescription.containsString("internet error") {
                        self.showAlert("Login Failed", message: "Check your internet connection")
                    }
                    
                    if error.debugDescription.containsString("bad request") {
                        self.showAlert("Login Failed", message: "Incorrect email and/or password")
                    }
                    
                }
            }
        }
        
    }
    
    
    @IBAction func signUpAction(sender: AnyObject) {
        let url = NSURL(string: "https://www.udacity.com")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: LoginViewController
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("NavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })
        
    }
    
    func showAlert(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: Modify UI
    func displayError(errorString: String?) {
       
    }
}