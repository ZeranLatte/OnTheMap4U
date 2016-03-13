//
//  Student.swift
//  OnTheMap
//
//  Created by ZZZZeran on 11/5/15.
//  Copyright © 2015 Z Latte. All rights reserved.
//

import UIKit
import MapKit




class Student: NSObject, MKAnnotation {
    
    static var studentArray: [Student] = [Student]()
    
    
    
    var coordinate: CLLocationCoordinate2D
    var title: String? = nil
    var subtitle: String? = nil
    
    init (title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    init?(dictionary: [String: AnyObject]) {
        if let first = dictionary["firstName"] as? String, let last = dictionary["lastName"] {
            self.title = "\(first) \(last)"
        }
        if let mediaURL = dictionary["mediaURL"] as? String {
            self.subtitle = mediaURL
        }
        if let lon = dictionary["longitude"] as? Double, let lat = dictionary["latitude"] as? Double {
            self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
        
    }
    
   
    
    struct currentStudent {
        static var key: String?
        static var firstName: String?
        static var lastName: String?
        static var mediaURL: String?
        static var mapString: String?
        static var latitude: Double?
        static var longitude: Double?
        
       
    }
    
    
    /* Helper: Given an array of dictionaries, convert them to an array of student objects */
    static func studentsFromResults(results: [[String : AnyObject]]) -> [Student] {
        var students = [Student]()
        
        for result in results {
            let lastName = result["lastName"] as! String
            let firstName = result["firstName"] as! String
            let name = "\(firstName) \(lastName)"
            let mediaURL = result["mediaURL"] as! String
            let latitude = result["latitude"] as! Double
            let longtitude = result["longitude"] as! Double
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            students.append(Student(title: name, subtitle: mediaURL, coordinate: coordinate))
        }
        return students
    }
}



