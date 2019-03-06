//
//  Work+CoreDataProperties.swift
//  1000Museums
//
//  Created by Brian Terry on 2/9/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Work {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Work> {
        return NSFetchRequest<Work>(entityName: "Work")
    }
    
    @NSManaged public var artist: String?
    @NSManaged public var artistID: Int32
    @NSManaged public var artistWikiURL: String?
    @NSManaged public var buyURL: String?
    @NSManaged public var caption: String?
    @NSManaged public var dimensions: String?
    @NSManaged public var height: Double
    @NSManaged public var id: Int32
    @NSManaged public var imagePath: String?
    @NSManaged public var locationID: Int32
    @NSManaged public var locationName: String?
    @NSManaged public var medium: String?
    @NSManaged public var name: String?
    @NSManaged public var publicDomain: Int32
    @NSManaged public var sortDate: Int32
    @NSManaged public var thumbnailImagePath: String?
    @NSManaged public var width: Double
    @NSManaged public var wikiURL: String?
    @NSManaged public var year: Int32
    @NSManaged public var year2: Int32
    @NSManaged public var imageFile: NSData?
    @NSManaged public var thumbnailFile: NSData?
    @NSManaged public var located: Location?
    @NSManaged public var paintedBy: Artist?
    
}
