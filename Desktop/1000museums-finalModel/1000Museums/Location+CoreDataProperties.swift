//
//  Location+CoreDataProperties.swift
//  1000Museums
//
//  Created by Brian Terry on 2/9/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var id: Int32
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var url: String?
    @NSManaged public var wiki_url: String?
    @NSManaged public var workCount: Int32
    @NSManaged public var paintingsHeld: NSSet?

}

// MARK: Generated accessors for paintingsHeld
extension Location {

    @objc(addPaintingsHeldObject:)
    @NSManaged public func addToPaintingsHeld(_ value: Work)

    @objc(removePaintingsHeldObject:)
    @NSManaged public func removeFromPaintingsHeld(_ value: Work)

    @objc(addPaintingsHeld:)
    @NSManaged public func addToPaintingsHeld(_ values: NSSet)

    @objc(removePaintingsHeld:)
    @NSManaged public func removeFromPaintingsHeld(_ values: NSSet)

}
