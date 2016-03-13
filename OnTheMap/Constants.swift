//
//  Constants.swift
//  OnTheMap
//
//  Created by ZZZZeran on 11/5/15.
//  Copyright © 2015 Z Latte. All rights reserved.
//
//Parse Application ID = QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr
//REST API Key = QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY
//Udacity Facebook App ID = 365362206864879

import Foundation


extension NetworkManager {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ParseID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let REST_API_Key: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let FacebookID: String = "365362206864879"
        
        // MARK: URLs
        static let UdacityURLSecure : String = "https://www.udacity.com/api/"
        static let parseURL: String = "https://api.parse.com/1/classes/"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        // MARK: GETting public UserData
        static let UserData = "users/{id}"
        static let StudentLocation = "StudentLocation"
        
        
        // MARK: Authentication
        static let CreatAsession = "session"
        static let LogOut = "session"
        
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
    }
        
    
    
}