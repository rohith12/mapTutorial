//
//  UserInfoViewController.swift
//  Rohith.p2.MapTutorial
//
//  Created by Rohith Raju on 9/15/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var nameTxt: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Play(sender: AnyObject) {
        
        if nameTxt.text?.characters.count > 0{
            
            NSUserDefaults.standardUserDefaults().setObject(nameTxt.text!, forKey: "Name")
        }else{
            
            alertViewFunc("Please enter your name")
        }
        performSegueWithIdentifier("play", sender: self)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        nameTxt.resignFirstResponder()
        
        return true
    }
    
    func alertViewFunc(msg: String)  {
        
        
        let alertController = UIAlertController(title: "\(msg)", message: "", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
