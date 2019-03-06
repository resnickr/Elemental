//
//  Location+CoreDataClass.swift
//  1000Museums
//
//  Created by Brian Terry on 2/9/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject, Comparable {
    public static func < (lhs: Location, rhs: Location) -> Bool {
        if(lhs.name! < rhs.name!) {
            return true
        }
        else {
            return false
        }
    }
    
    
    func getName() -> String{
        return self.name!
    }
}
