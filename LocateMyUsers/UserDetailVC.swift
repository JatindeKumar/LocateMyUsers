//
//  MapViewController.swift
//  LocateMe
//
//  Created by Jatinder Kumar on 12/06/19.
//  Copyright © 2019 Jatinder Kumar. All rights reserved.
//

import MapKit
import UIKit
import main

class UserDetailVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var selectedUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedUser.firstName + "'s" + " Locations"
        setUpMapView()
    }
    
    /// Configure Map View and show annotations
    fileprivate func setUpMapView() {
        mapView.delegate = self
        var zoomRect = MKMapRectNull
        for (index, userlocation) in selectedUser.lastLocations.enumerated() {
            let location = UserAnnotation()
            location.user = selectedUser
            location.lat = userlocation.latitude
            location.lon = userlocation.longitude
            location.title = selectedUser.firstName + " location no " + String(index+1)
            location.coordinate = CLLocationCoordinate2D(latitude: userlocation.latitude, longitude: userlocation.longitude)
            mapView.addAnnotation(location)
            let annotationPoint = MKMapPointForCoordinate(location.coordinate)
            let pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0)
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect)
            }
        }
        self.mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(10, 10, 10, 10), animated: true)
    }
}

extension UserDetailVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? UserAnnotation {
            //>> Get Location Name by Latitude & Longitude <<//
            getLocationNamefrom(locLatitude: annotation.lat, locLongitude: annotation.lon, completionHandler: { placemark  in
                
                let userName =  self.getCustomizedTitle(plainText: "Name: ", customTitle: self.selectedUser.firstName + " " + self.selectedUser.lastName)
                let locationName =  self.getCustomizedTitle(plainText: "Location: ", customTitle: (placemark?.name ?? ""))
                
                //Show popup with details
                let infoAlert = UIAlertController(title: "",
                                                  message: "",
                                                  preferredStyle: .alert)
                infoAlert.setValue(userName, forKey: "attributedTitle")
                infoAlert.setValue(locationName, forKey: "attributedMessage")
                infoAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(infoAlert, animated: true, completion: nil)
                
            })
            
        }
    }
    
    /// getLocationNamefromlocLatitude:locLongitude:completionHandler:
    ///
    /// - Parameters:
    ///   - locLatitude: Latitude of the location
    ///   - locLongitude: Longitude of the location
    ///   - completionHandler: Returns the result once completed
    private func getLocationNamefrom(locLatitude:CLLocationDegrees, locLongitude:CLLocationDegrees, completionHandler: @escaping (CLPlacemark?) -> Void)  {
        
        let userLocation = CLLocation(latitude: locLatitude, longitude: locLatitude)
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
            else {
                // An error occurred during geocoding.
                print(error?.localizedDescription as Any)
                completionHandler(nil)
            }
        })
    }
    
    private func getCustomizedTitle(plainText:String, customTitle: String) -> NSAttributedString {
        
        let attributedString = NSMutableAttributedString(string:plainText)
        let boldFont = UIFont.boldSystemFont(ofSize: 17)
        let fontAttribute = [NSAttributedStringKey.font: boldFont]
        let boldString = NSMutableAttributedString(string: customTitle, attributes:fontAttribute)
        attributedString.append(boldString)
        return attributedString
        
    }
}

