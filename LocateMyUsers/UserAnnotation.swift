//
//  UserAnnotation.swift
//  LocateMe
//
//  Created by Jatinder Kumar on 12/06/19.
//  Copyright © 2019 Jatinder Kumar. All rights reserved.
//

import Foundation
import MapKit
import  main

class UserAnnotation: MKPointAnnotation {
    var user: User!
    var lat: Double = 0
    var lon: Double = 0
}
