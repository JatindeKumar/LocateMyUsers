//
//  ViewController.swift
//  LocateMe
//
//  Created by Jatinder Kumar on 12/06/19.
//  Copyright © 2019 Jatinder Kumar. All rights reserved.
//

import UIKit
import main
import MapKit

class AllUserVC: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tblView: UITableView!
    var usersArray: [User]?
    var mapViewShown = true
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        refreshUserList()
        setUpDelegateDataSource()
    }
    private func setUpDelegateDataSource(){
        tblView.dataSource = self
        tblView.delegate = self
        mapView.delegate = self
    }
    private func getUsers() {
        let users = UserApi().getUsers()
        if  let currentUsers = usersArray {
            usersArray?.removeAll()
            usersArray = currentUsers + users
        }
        else {
            usersArray = users
        }
        
        usersArray = usersArray?.sorted { $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == ComparisonResult.orderedAscending }
        tblView.reloadData()
        var zoomRect = MKMapRectNull

        for user in users {
            let location = UserAnnotation()
            location.user = user
            location.title = user.firstName + "\n" + user.lastName
            location.coordinate = CLLocationCoordinate2D(latitude: user.lastLocation.latitude, longitude: user.lastLocation.longitude)
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
    private func setUpNavigationBar() {
        self.title = "Users"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshUserList))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: mapViewShown ? "ListView" : "MapView", style: .plain, target: self, action: #selector(viewMode))
        
    }
    @objc func refreshUserList() {
        getUsers()
    }
    @objc func viewMode() {
        mapViewShown = !mapViewShown
        self.view.bringSubview(toFront: mapViewShown ? mapView : tblView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: mapViewShown ? "ListView" : "MapView", style: .plain, target: self, action: #selector(viewMode))
    }
}

extension AllUserVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? UserAnnotation {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let objUserDetailVC = storyBoard.instantiateViewController(withIdentifier: "UserDetailVC") as? UserDetailVC {
                objUserDetailVC.selectedUser = annotation.user
                self.navigationController?.pushViewController(objUserDetailVC, animated: true)
            } else {
                print("Storyboard configuration tempered")
            }
        }
    }
}

// MARK:-  Table view DataSource & Delegates
extension AllUserVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as UITableViewCell
        if let optionalUsersArray = usersArray, optionalUsersArray.count > indexPath.row {
            cell.accessoryType = .disclosureIndicator
            let user = optionalUsersArray[indexPath.row]
            cell.textLabel?.text = user.firstName + " " + user.lastName
        } else {
            print("Tableview configuration tempered")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let optionalUsersArray = usersArray, optionalUsersArray.count > indexPath.row {
            let user = optionalUsersArray[indexPath.row]
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            if let objUserDetailVC = storyBoard.instantiateViewController(withIdentifier: "UserDetailVC") as? UserDetailVC {
                objUserDetailVC.selectedUser = user
                self.navigationController?.pushViewController(objUserDetailVC, animated: true)
            } else {
                print("Tableview configuration tempered")
            }
            
        }
    }
}
