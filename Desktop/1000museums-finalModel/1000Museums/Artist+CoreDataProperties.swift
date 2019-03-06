//
//  Artist+CoreDataProperties.swift
//  1000Museums
//
//  Created by Brian Terry on 2/9/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Artist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Artist> {
        return NSFetchRequest<Artist>(entityName: "Artist")
    }

    @NSManaged public var id: Int32
    @NSManaged public var imagePath: String?
    @NSManaged public var name: String?
    @NSManaged public var workCount: Int32
    @NSManaged public var painted: Work?

}
