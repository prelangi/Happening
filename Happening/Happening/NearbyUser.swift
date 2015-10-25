//
//  nearbyUser.swift
//  Happening
//
//  Created by Douglas Hewitt on 10/25/15.
//  Copyright © 2015 TeamAwesomeHackingEDU. All rights reserved.
//

import MapKit

class NearbyUser: NSObject, MKAnnotation {

    let title: String?
    let skills: NSArray
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, skills: NSArray, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.skills = skills
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return title
    }
}
