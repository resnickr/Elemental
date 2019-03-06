//
//  Artist+CoreDataClass.swift
//  1000Museums
//
//  Created by Brian Terry on 2/9/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Artist)
public class Artist: NSManagedObject, Comparable {
    public static func < (lhs: Artist, rhs: Artist) -> Bool {
        if(lhs.name! < rhs.name!) {
            return true
        }else{
        return false
        }
    }
    

}
