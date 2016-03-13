//
//  StudentListViewController.swift
//  OnTheMap
//
//  Created by ZZZZeran on 11/5/15.
//  Copyright © 2015 Z Latte. All rights reserved.
//

import Foundation

import UIKit

// MARK: - WatchlistViewController: UIViewController

class StudentListViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var studentsTableView: UITableView!
    
    let cellResueIdentifier = "studentCell"
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.studentsTableView.reloadData()        
    }
    
    func loadStudentData() {
        NetworkManager.sharedInstance().getStudentLocation() { students, error in
            if let _ = error {
                self.showAlert("Failed to obtain data", message: "Check your network settings")
            }
            
            if let students = students {
                Student.studentArray = students
                dispatch_async(dispatch_get_main_queue()) {
                    self.studentsTableView.reloadData()
                }
            } else {
                print(error)
            }
        }
    }
    
    
    func showAlert(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
    }
    
}


extension StudentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentTableViewCell"
        let student = Student.studentArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = student.title
        cell.imageView!.image = UIImage(named: "map2")
        cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Student.studentArray.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = Student.studentArray[indexPath.row]
        let url = NSURL(string: student.subtitle!)
        UIApplication.sharedApplication().openURL(url!)
        
    }
}