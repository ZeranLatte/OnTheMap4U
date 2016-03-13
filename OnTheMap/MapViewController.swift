//
//  MapViewController.swift
//  OnTheMap
//
//  Created by ZZZZeran on 11/5/15.
//  Copyright © 2015 Z Latte. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    //constants
    var annotations = [MKPointAnnotation]()


    let regionRadius: CLLocationDistance = 25000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        //set initial location in Honolulu, HI
        let initialLocation = CLLocation(latitude: 37.423021, longitude: -122.083739)
        centerMapLocation(initialLocation)
        loadInitialData()
    }
    
    
    //helper method specifying the rectangular region of map
    func centerMapLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius*2.0, regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //load json data
    func loadInitialData() {
        NetworkManager.sharedInstance().getStudentLocation() { students, error in
            if let _ = error {
                self.showAlert("Failed to obtain data", message: "Check your network settings")
            }
            if let students = students {
                
                Student.studentArray = students
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.addMapAnnotation(Student.studentArray)
                    self.mapView.addAnnotations(self.annotations)
                }
            } else {
                print(error)
            }
        }
        
    }
    
    func reloadMapData() {
        self.annotations.removeAll()
        loadInitialData()
    }
    
    func showAlert(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    
    // add annotations from student array
    func addMapAnnotation(students: [Student]) {
        
        for student in students {
            let name = student.title
            let url = student.subtitle
            let coor = student.coordinate
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coor
            annotation.title = name
            annotation.subtitle = url
            
            annotations.append(annotation)
        }
    }
    
    
}

extension MapViewController: MKMapViewDelegate {
    
    // - 1
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            
        }
        return view
    }
    
    // when callout button is tapped
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
}


