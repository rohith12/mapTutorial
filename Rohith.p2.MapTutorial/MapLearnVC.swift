//
//  MapLearnVC.swift
//  Rohith.p2.MapTutorial
//
//  Created by Rohith Raju on 9/14/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

class MapLearnVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapVw: MKMapView!
    @IBOutlet weak var topLbl: UILabel!
    var selectedCountry = ""
    let locationManager = CLLocationManager()

    
    func receiveCountry(Country: String){
        
        selectedCountry = Country
    }
    
    
    func forwardGeoCoding(name:String){
        
        CLGeocoder().geocodeAddressString(name) { (placemarks:
            [CLPlacemark]?, error: NSError?) -> Void in
            if (placemarks?.count > 0) {
                
                let topResult: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                
                print("placeMark:\(placemark.location?.coordinate.latitude,placemark.location?.coordinate.longitude)")
               
                
                self.setupYourMap(placemark)
                
            }}
        
    }
    
    func reverseGeoCode(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        var loction = CLLocation()
        loction = CLLocation(latitude: latitude,
                             longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(loction, completionHandler: { (result: [CLPlacemark]?, err: NSError?) -> Void in
            if let placemark = result?.last
                , addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String]
            {
                
                let address =  addrList.joinWithSeparator(", ")
                self.topLbl.text = address
                print(address)
            }
        })
    }
    
    
    func postalAddressFromAddressDictionary(addressdictionary: Dictionary<NSObject,AnyObject>) -> CNMutablePostalAddress {
        
        let address = CNMutablePostalAddress()
        
        address.street = addressdictionary["Street"] as? String ?? ""
        address.state = addressdictionary["State"] as? String ?? ""
        address.city = addressdictionary["City"] as? String ?? ""
        address.country = addressdictionary["Country"] as? String ?? ""
        address.postalCode = addressdictionary["ZIP"] as? String ?? ""
        
        return address
    }

    func localizedStringForAddressDictionary(addressDictionary: Dictionary<NSObject,AnyObject>) -> String {
        
        return CNPostalAddressFormatter.stringFromPostalAddress(postalAddressFromAddressDictionary(addressDictionary), style: .MailingAddress)
    }

    
    func setupYourMap(placemark:MKPlacemark){
        
        let span = MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(placemark.coordinate, span)
        mapVw.setRegion(region, animated: true)
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topLbl.adjustsFontSizeToFitWidth = true
        setupLocationManager()
        // Do any additional setup after loading the view.
    }
    
    func setupLocationManager(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        forwardGeoCoding(selectedCountry)
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        reverseGeoCode(self.mapVw.region.center.latitude,longitude: self.mapVw.region.center.longitude)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
