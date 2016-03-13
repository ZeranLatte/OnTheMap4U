//
//  Convenience.swift
//  OnTheMap
//
//  Created by ZZZZeran on 11/5/15.
//  Copyright © 2015 Z Latte. All rights reserved.
//

import Foundation
import UIKit


extension NetworkManager {
    
    
    func authenticateToUdacity(email: String, password: String, hostVC: UIViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        let parameters = [String: AnyObject]()
        
        let parameterForBody = [
        "username": email,
        "password": password
        ]
        let udacity = ["udacity": parameterForBody]
        taskForPOSTMethod(Methods.CreatAsession, parameters: parameters, jsonBody: udacity) { (JSONResult, error) in
            
            if let _ = error {
                
                completionHandler(success: false, errorString: "internet error")
            } else {
                if let results = JSONResult["session"] as? [String: AnyObject] {
                    if let retrievedSessionID = results["id"] as? String {
                        NetworkManager.sharedInstance().sessionID = retrievedSessionID
                    }
                    if let account = JSONResult["account"] as? [String: AnyObject] {
                        if let key = account["key"] as? String {
                            NetworkManager.sharedInstance().userID = key
                            Student.currentStudent.key = key
                        }
                    }
                    completionHandler(success: true, errorString: nil)
                } else {
                    completionHandler(success: false, errorString: "bad request")
                }
            }
        }
    }// end of authenticate method
    
    
    //MARK: retrieve 100 students location
    func getStudentLocation(completionHandler: (result: [Student]?, error: NSError?) -> Void) {
        let parameters = [
        "limit": 100,
        "order": "-updatedAt"
        ]
        
        taskForParseGETMethod(Methods.StudentLocation, parameters: parameters) { (JSONResult, error) -> Void in
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                if let results = JSONResult["results"] as? [[String : AnyObject]] {
                    let students = Student.studentsFromResults(results)
                    completionHandler(result: students, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "get publicUserData parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse public user data"]))
                }
            }
        }
    } //end of getStudentLocationData
    
    func postAStudentLoaction(completionHandler: (JSONResult: AnyObject?, error: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let mutableMethod: String = Methods.StudentLocation
        let jsonBody : [String:AnyObject] = [
            "uniqueKey": "movie",
            "firstName": Student.currentStudent.firstName!,
            "lastName": Student.currentStudent.lastName!,
            "mapString": Student.currentStudent.mapString!,
            "mediaURL": Student.currentStudent.mediaURL!,
            "latitude": Student.currentStudent.latitude!,
            "longitude": Student.currentStudent.longitude!
        ]
        
        taskForParsePOSTMethod(mutableMethod, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error {
                completionHandler(JSONResult: nil, error: error)
            } else {
                completionHandler(JSONResult: result, error: nil)
            }
        }
    }
    
    func getUserData(userID: String, completionHandler: (data: [String: AnyObject]?, error: NSError?) -> Void) {
        let parameter = [String: AnyObject]()
        
        var mutableMethod = Methods.UserData
        mutableMethod = NetworkManager.subtituteKeyInMethod(mutableMethod, key: "id", value: Student.currentStudent.key!)!
        
        taskForGETMethod(mutableMethod, parameters: parameter) { (result, error) -> Void in
            if let error = error {
                completionHandler(data: nil, error: error)
            } else {
                if let userData = result["user"] as? [String: AnyObject] {
                    if let firstName = userData["first_name"], let lastName = userData["last_name"] {
                        Student.currentStudent.firstName = firstName as? String
                        Student.currentStudent.lastName = lastName as? String
                        completionHandler(data: userData, error: nil)
                    }
                } else {
                    print("no user data")
                }
            }
        }
    }
    
    func logout(completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        let urlString = Constants.UdacityURLSecure + Methods.LogOut
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(success: false, error: error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            completionHandler(success: true, error: nil)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
        
}