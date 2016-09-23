//
//  mapQuizViewController.swift
//  Rohith.p2.MapTutorial
//
//  Created by Rohith Raju on 9/15/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class mapQuizViewController: UIViewController,MKMapViewDelegate ,CLLocationManagerDelegate{

    @IBOutlet weak var toplbl: UILabel!
    
    var lifes = 10
    var score = 0
    let synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    
    @IBOutlet weak var lifeLbl: UILabel!
    @IBOutlet weak var ptLbl: UILabel!
    @IBOutlet weak var mapVw: MKMapView!
    var nameAbbreviations = [String : String]()
    var selectedState = ""
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        createDict()
        setupLocationManager()
        addGesture()
        startGame()
        // Do any additional setup after loading the view.
    }
    
    
    func startGame(){
        lifes = 3
        score = 0
        self.ptLbl.text = "Points:\(score)"
        self.lifeLbl.text = "Lifes:\(lifes)"
        randomString()
 
    }
    
    func randomString(){
        
        let randDigit = Int(arc4random_uniform(50))
        
       let allStates = Array(nameAbbreviations.keys)
         selectedState = allStates[randDigit]
        let dictValue = nameAbbreviations[selectedState]
        
        self.toplbl.text = "Find the \(dictValue!) on the map"
        myUtterance = AVSpeechUtterance(string: self.toplbl.text!)
        myUtterance.rate = 0.3
        synth.speakUtterance(myUtterance)
    }
    
    func alertView (msg: String,place : String){
        
        var defaultAction = UIAlertAction()
        var alertController = UIAlertController()
        if msg == "correct" {
            
             alertController = UIAlertController(title: " you're \(msg)  ", message: "", preferredStyle: .Alert)
            defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { action in self.resetGame()
            
            
            })
        }
        else if  msg == "your game has ended"{
            
            alertController = UIAlertController(title: "\(msg)", message: "", preferredStyle: .Alert)
            defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { action in
                
                self.resetGame()
                
                }
            )
        }
        
        else{
            let dictValue = nameAbbreviations[place]

            if place.characters.count > 1 || dictValue != nil {
            
                alertController = UIAlertController(title: " you're \(msg)  ", message: "You selected \(dictValue!)", preferredStyle: .Alert)
                defaultAction = UIAlertAction(title: "OK", style: .Default, handler:nil)
            }else{
                alertController = UIAlertController(title: " you're \(msg)  ", message: "", preferredStyle: .Alert)
                defaultAction = UIAlertAction(title: "OK", style: .Default, handler: { action in
                    
                    self.popBack()
                    
                    })
            }
            
        }
        
       
        
       
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func resetGame(){
        
        self.randomString()
    }
    
    func popBack(){
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setupYourMap(){
        
        let span = MKCoordinateSpan(latitudeDelta: 32, longitudeDelta: 32)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(39.743620, -101.674996), span)
        mapVw.setRegion(region, animated: true)
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGesture(){
        
        let gestureRecog = UITapGestureRecognizer(target: self, action: #selector(mapQuizViewController.action(_:)))
        gestureRecog.numberOfTapsRequired = 2
        gestureRecog.numberOfTouchesRequired = 1
        
        self.mapVw.addGestureRecognizer(gestureRecog)
    }

    
    func action(gesture: UIGestureRecognizer){
        
        if (gesture.state != UIGestureRecognizerState.Ended) {
            
           return
            
        }
        
        let coordinates = mapVw.convertPoint(gesture.locationInView(self.mapVw), toCoordinateFromView: self.mapVw)
        
        addAnnotation(coordinates)
        reverseGeoCode(CLLocation(latitude: coordinates.latitude,longitude:  coordinates.longitude))
        
        
    }
    
    func addAnnotation(loc: CLLocationCoordinate2D){
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = loc
        mapVw.addAnnotation(annotation)
        

    }
    
    func setupLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        setupYourMap()

    }
    
    
    func reverseGeoCode(location: CLLocation){
        
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                
                
                let pm = placemarks![0]
                
                if pm.administrativeArea != nil{
                print(pm.administrativeArea!)
                if pm.administrativeArea! == self.selectedState{
                    
                    
                    self.score = self.score + 10
                    self.ptLbl.text = "Points:\(self.score)"
                    self.alertView("correct",place: "")
                    print("true:\(pm.administrativeArea),\(self.selectedState)")
                }
                else{
                    
                    if self.lifes != 0{
                    self.lifes = self.lifes - 1
                    }
                    
                    if self.lifes == 0{
                      
                        self.removeAnnotation()
                        self.startGame()
                       let name = NSUserDefaults.standardUserDefaults().valueForKey("Name")
                        if name != nil{
                            self.alertView("\(name!) your game has ended",place: "")
  
                        }else{
                            self.alertView("your game has ended",place: "")

                        }
                        
                    }else{
                        self.lifeLbl.text = "Lifes:\(self.lifes)"
                        self.alertView("wrong",place: pm.administrativeArea!)
                        print("false:\(pm.administrativeArea),\(self.selectedState)")
                        
                    }
                    
                    
                }
                
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func removeAnnotation(){
        let allAnnotations = self.mapVw.annotations
        self.mapVw.removeAnnotations(allAnnotations)
    }
    
    func createDict(){
        
        nameAbbreviations = [
            "AL":"Alabama",
            "AK":"Alaska" ,
            "AZ":"Arizona",
            "AR":"Arkansas",
            "CA":"California" ,
            "CO":"Colorado" ,
            "CT":"Connecticut",
            "DE":"Delaware" ,
            "DC":"District of columbia",
            "FL":"Florida",
            "GA": "Georgia",
            "HI":"Hawaii",
            "ID": "Idaho",
            "IL":"Illinois" ,
            "IN":"Indiana",
            "IA":"Iowa",
            "KS":"Kansas" ,
            "KY": "Kentucky",
            "LA": "Louisiana",
            "ME": "Maine",
            "MD":"Maryland",
            "MA":"Massachusetts",
            "MI": "Michigan",
            "MN": "Minnesota",
            "MS": "Mississippi",
            "MO":"Missouri",
            "MT": "Montana",
            "NE":"Nebraska",
            "NV":"Nevada",
            "NH":"New hampshire",
            "NJ":"New jersey",
            "NM": "New mexico" ,
            "NY": "New york",
            "NC":"North carolina",
            "ND":"North dakota",
            "OH": "Ohio",
            "OK": "Oklahoma",
            "OR": "Oregon",
            "PA":"Pennsylvania", "RI":"Rhode island",
            "SC": "South carolina",
            "SD":"South dakota",
            "TN":"Tennessee",
            "TX": "Texas",
            "UT": "Utah",
            "VT": "Vermont",
            "VA":"Virginia",
            "WA":"Washington" ,
            "WV":"West virginia",
            "WI":"Wisconsin",
            "WY": "Wyoming"
        ]

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
