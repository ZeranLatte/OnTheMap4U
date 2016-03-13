//
//  TabViewController.swift
//  OnTheMap
//
//  Created by ZZZZeran on 11/11/15.
//  Copyright © 2015 Z Latte. All rights reserved.
//

import Foundation
import UIKit


class TabViewController: UITabBarController {
    
    
//    @IBAction func post(sender: AnyObject) {
//        
//        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("PostingController") 
//        self.presentViewController(controller, animated: true, completion: nil)
//    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        
        
        if self.selectedIndex == 0 {
            let mapVC = self.selectedViewController as! MapViewController
            mapVC.reloadMapData()
        } else {
            let tableVC = self.selectedViewController as! StudentListViewController
            tableVC.studentsTableView.reloadData()
        }
        
        
    }
    
    func showAlert(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
    }

    
    @IBAction func logoutTapped(sender: AnyObject) {
        let loggedoutController = presentingViewController as? LoginViewController
        loggedoutController?.passwordTF.text = ""
        loggedoutController?.emailTF.text = ""
        Student.currentStudent.key = nil
        Student.currentStudent.firstName = nil
        Student.currentStudent.lastName = nil
        Student.currentStudent.mediaURL = nil
        Student.currentStudent.mapString = nil
        Student.currentStudent.latitude = nil
        Student.currentStudent.longitude = nil
        NetworkManager.sharedInstance().logout { (success, error) -> Void in
            if let error = error {
                print("error: \(error)")
                
            } else {
                if success {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    })
                }
            }
        }
    }
}