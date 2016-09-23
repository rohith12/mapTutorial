//
//  LearnTableViewController.swift
//  Rohith.p2.MapTutorial
//
//  Created by Rohith Raju on 9/14/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit

class LearnTableViewController: UITableViewController {
    
    var arrayOfCont = [String]()
    var subsections = [[String]]()
    var selectedString = ""
    var dictOfContStates = [String : [String]]()
    var dictionaryOfStatesAndNumbers = [String : Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        self.dictionaryOfStatesAndNumbers = ["asia" : 0 ,"north america" : 1,"south america" : 2,"australia" : 3,"europe" : 4,"africa" : 5,"others" : 6]
        
        self.arrayOfCont = ["Asia","North America","South America","Australia","Europe","Africa","Others"]
        
        self.subsections = [["India","China","Russia","Japan","North Korea"," Saudi Arabia","Afghanistan","Indonesia","Philippines"]
            
            ,["USA","Canada","Mexico","Alaska","Greenland"],
             ["Argentina","Brazil","Bolivia","Peru","Venezula","Colombia","Paraguay","Venezula","Chile","Ecuador"],
             
             ["Syndney","New South Wales","Queensland","New Zeland"],
             
["UK","Germany","Ireland","Norway","Finland","Latvia","Belarus","Poland","Georgia","Ukraine","Italy","France","Spain","Netherland","Vatican","Serbia","Austria","Iceland"],

["Egypt","South Africa","Algeria","Tunisia","Mali","Chad","Cote D'Ivorie","Cameroon","Uganda","Kenya","Somalia","Congo","Tanzania","Zambia","Botswana","Madagascar"],[]
        
        ]
        
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }

    @IBAction func addToTableView(sender: AnyObject) {
        
        addAlertView()
    }
    
    
    func addAlertView(){
        
        let controller = UIAlertController(title: "Add the place you want to explore", message: "", preferredStyle: .Alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .Destructive) { (action) in
            print("Dismiss button tapped!")
            
            let text = controller.textFields?.first?.text
            print("Textfield text \(text!)")
            
            let text2 = controller.textFields?[1].text
            
            print("text2\(text2!)")
            
           let str = self.dictionaryOfStatesAndNumbers[text!]
            
            self.addToTable(str!, text: text2!)
            
            
            
        }
        
        controller.addAction(alertAction)
        
        controller.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Enter the Continent"
            textField.textColor = UIColor.blackColor()
        }

        
        controller.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Enter the place"
            textField.textColor = UIColor.blackColor()
        }
        
        
        
        
        presentViewController(controller, animated: true, completion: nil)
    
    }
    
   


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        return self.arrayOfCont.count

    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        
        return self.arrayOfCont[section]
        
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
         return self.subsections[0].count
            
        }else if section == 1{
            return self.subsections[1].count

        }
        else if section == 2{
            return self.subsections[2].count

        }else if section == 3{
            return self.subsections[3].count

        }else if section == 4{
            return self.subsections[4].count

        }else if section == 5{
            return self.subsections[5].count

        }else if section == 6{
            
            
            if self.subsections[6].count == 0 {
                return 0
            }else{
              return  self.subsections[6].count
            }
        }
        
        return 0
    }
    
    
    func addToTable(section:Int, text: String){
        
        
        
         if section == 6{
            
            
            if self.subsections[6].count == 0 {
                self.subsections[6].append(text)
                self.tableView.reloadData()
            }else{
                self.subsections[6].append(text)

                self.tableView.reloadData()
            }
            
            
          
         }else{
            self.subsections[section].append(text)
            self.tableView.reloadData()
        }

        
}

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.subsections[indexPath.section][indexPath.row]
        return cell
        
    }
    
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    
    
    self.selectedString = self.subsections[indexPath.section][indexPath.row]
     performSegueWithIdentifier("map", sender: self)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destVC = segue.destinationViewController as? MapLearnVC {
            destVC.receiveCountry(self.selectedString)
        }

        
        
    }
    
  override  func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
   override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            
            self.subsections[indexPath.section].removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }


 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    

}
