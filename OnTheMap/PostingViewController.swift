//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by ZZZZeran on 11/11/15.
//  Copyright © 2015 Z Latte. All rights reserved.

//  latitude 37.423021 and longitude -122.083739
//

import Foundation
import UIKit
import MapKit

class PostingViewController: UIViewController {
    
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var middleMapView: MKMapView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var whereLabel: UIStackView!
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var textField4Location: UITextField!
    
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    // Constants
    let regionRadius: CLLocationDistance = 50000
    
    //properties
    var userAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialUI()

        
        let initialLocation = CLLocation(latitude: 37.423021, longitude: -122.083739)
        centerMapLocation(initialLocation)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    @IBAction func cancelButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //helper method specifying the rectangular region of map
    func centerMapLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2.0, regionRadius*2.0)
        middleMapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // MARK: UI control
    func loadInitialUI() {
        
        self.middleMapView.hidden = true
        self.urlTextField.hidden = true
        self.submitButton.hidden = true
        self.view.backgroundColor = UIColor(red: 0.13, green: 0.30, blue: 0.57, alpha: 1.0)
        self.findButton.hidden = false
        self.whereLabel.hidden = false
        self.textField4Location.hidden = false
    }
    
    func loadMapScene() {
        
        self.view.backgroundColor = nil
        self.findButton.hidden = true
        self.whereLabel.hidden = true
        self.textField4Location.hidden = true
        
        self.middleMapView.hidden = false
        self.urlTextField.hidden = false
        self.submitButton.hidden = false
        self.topView.backgroundColor = UIColor(red: 0.13, green: 0.30, blue: 0.57, alpha: 1.0)
    }
    
    
    @IBAction func findButtonTapped(sender: UIButton) {
        
        activityIndicatorView.startAnimating()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            self.findLocation({ (success) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicatorView.stopAnimating()
            })
        })
        }
    }
    
    func findLocation(completionHandler: (success: Bool) -> Void) {
        
        guard textField4Location.text != "" else {
            //handle empty input or wrong input
            showAlert("Warning", message: "Empty input")
            completionHandler(success: true)
            return
        }
        
        let geocoder = CLGeocoder()
        let address = textField4Location.text!
        geocoder.geocodeAddressString(address) { (placemarks, error) -> Void in
            guard (error == nil) else {
                print(error!.description)
                self.showAlert("Geocoding failed", message: "Check internet connection or try different input")
                return
            }
            
            if let placemark = placemarks?.first {
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                print("Found user location: \(coordinates)")
                self.userAnnotation.coordinate = coordinates
                self.middleMapView.addAnnotation(self.userAnnotation)
                self.loadMapScene()
                self.centerMapLocation(placemark.location!)
                
                // store current student data
                Student.currentStudent.mapString = self.textField4Location.text!
                Student.currentStudent.latitude = coordinates.latitude
                Student.currentStudent.longitude = coordinates.longitude
            } else {
                self.showAlert("Failed", message: "Your location is not found, please try a diferent one")
            }
        }
        completionHandler(success: true)

    }

    @IBAction func submitButtonTapped(sender: UIButton) {
        
        guard urlTextField.text != nil else {
            print("Empty input")
            return
        }
        
        if veryfiyURL(urlTextField.text!) {
            Student.currentStudent.mediaURL = urlTextField.text!
            NetworkManager.sharedInstance().getUserData(Student.currentStudent.key!, completionHandler: { (data, error) -> Void in
                if let error = error {
                    self.showAlert("Failed", message: "Check internet connection")
                    print(error)
                } else {
                    self.submitStudentLocation()
                }
            })
        }
    }
    
    
    // Helper method
    
    func veryfiyURL(urlString: String) -> Bool {
        if let url = NSURL(string: urlString) {
            if UIApplication.sharedApplication().canOpenURL(url) {
                return true
            }
        }
        return false
    }
    
    
    
    func submitStudentLocation() {
        NetworkManager.sharedInstance().postAStudentLoaction({ (JSONResult, error) -> Void in
            if let _ = error {
                self.showAlert("Post failed", message: "Submission failed, check internet connection")
            } else {
                self.showAlert("Success", message: "Your information is successfully submitted")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    func showAlert(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
    }
    
}

extension PostingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

