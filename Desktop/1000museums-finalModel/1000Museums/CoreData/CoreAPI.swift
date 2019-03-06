//
//  CoreAPI.swift
//  1000Museums
//
//  Created by Brian Terry on 1/31/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import Foundation
import CoreData
import UIKit
///API that allows access to Core Data and network functionality in 1000Museums
class CoreAPI {
    
    /// toggle provides only buyable art if true, all art if false
    private var displayBuyableOnly = false
    init() {
        
    }
    /// Initializes Coredata functionality
    ///```
    ///coreAPI.initDatabase { (didComplete) in completion(didComplete)
    ///```
    /// Calls back with a boolean if initialized correctly
    func initDatabase(completion: @escaping (_ didComplete: Bool) -> Void){
        
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = TheModel.sharedInstance.persistenceManager.context
        
        let firstParser = ArtistParser()
        let secondParser = LocationParser()

        privateMOC.perform {
            let myGroup = DispatchGroup()
            myGroup.enter()
            firstParser.parseFeed(url:"https://community.artauthority.net/aaservice.asp?action=artistlist", context: privateMOC) { (artists) in
                myGroup.leave()
            }
            myGroup.enter()
            secondParser.parseFeed(url:"https://community.artauthority.net/aaservice.asp?action=locationlist",context: privateMOC) { (locations) in
                myGroup.leave()
            }
            myGroup.notify(queue: .main) {
                completion(true)
            }
        }
    }
    /// Private function returns number of records for an entity.
    private func numRecords(for entity: String) -> Int {
        var numRecords = 0
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            var content: [NSManagedObject]? = nil
            switch entity {
            case "Artist": content = try TheModel.sharedInstance.persistenceManager.context.fetch(fetchRequest) as? [Artist]
            case "Work": content = try TheModel.sharedInstance.persistenceManager.context.fetch(fetchRequest) as? [Work]
            case "Location": content = try TheModel.sharedInstance.persistenceManager.context.fetch(fetchRequest) as? [Location]
            default: return 0
            }
            if(content!.count > 0){
                numRecords = content!.count
            }
        }catch{
            print("error")
        }
        return numRecords
    }
    /// retrieves all locations in CoreData
    ///```
    ///let myLocations = coreAPI.retrieveAllLocations()
    ///```
    ///returns an array of type Location
    func retrieveAllLocations() -> [Location]{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
            let sort = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            let locations = try TheModel.sharedInstance.persistenceManager.context.fetch(fetchRequest) as? [Location]
            if locations!.count > 0 {
                return locations ?? []
            }
        }catch{
            print("error")
        }
        return []
    }
    /// retrieves all Artists in CoreData
    ///```
    ///let myArtists = coreAPI.retrieveAllArtists()
    ///```
    ///returns an array of type Artist
    func retrieveAllArtists() -> [Artist]{
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
            let sort = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            let artists = try TheModel.sharedInstance.persistenceManager.context.fetch(fetchRequest) as? [Artist]
            if artists!.count > 0 {
                return artists ?? []
            }
        }catch{
            print("error")
        }
        return []
    }
    /// Retrieves an array of works by artist ID from CoreData
    ///```
    /// coreAPI.retrieveWorksByArtistID(id: Int32) { (works) in }
    ///```
    ///Calls back with works with Artist ID id
    func retrieveWorksByArtistID(id: Int32) -> [Work]{
        var buyBool = ""
        if(self.displayBuyableOnly) {
            buyBool = "AND buyURL != \"\""
        }
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Work")
            let sort = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.predicate = NSPredicate(format: "artistID = %d \(buyBool)", id)
            fetchRequest.sortDescriptors = [sort]
            let works = try TheModel.sharedInstance.persistenceManager.context.fetch(fetchRequest) as? [Work]
            if works!.count > 0 {
                return works!
            }else{
                return []
            }
        }catch{
            print("error")
        }
        return []
    }
    /// Retrieves an array of works by Location ID from CoreData
    ///```
    /// coreAPI.retrieveWorksByLocationID(id: Int32) { (works) in }
    ///```
    ///Calls back with works with Location ID id
    func retrieveWorksByLocationID(id: Int32) -> [Work]{
        var buyBool = ""
        if(self.displayBuyableOnly) {
            buyBool = "AND buyURL != \"\""
        }
        do{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Work")
            fetchRequest.predicate = NSPredicate(format: "locationID = %d \(buyBool)", id)
            let sort = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [sort]
            let works = try TheModel.sharedInstance.persistenceManager.context.fetch(fetchRequest) as? [Work]
            if works!.count > 0 {
                return works!
            }else {
                return []
            }
        }catch{
            print("error")
        }
        return []
    }
    /// Fetches works from web by Location ID
    ///```
    ///coreAPI.downloadWorksByLocationID(id: Int32)
    ///```
    ///Once finished, populates CoreData with works.
    func downloadWorksByLocationID(id: Int32, completion: @escaping () -> Void) {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = TheModel.sharedInstance.persistenceManager.context
        privateMOC.perform {
            let parser = WorkParser()
            parser.parseFeed(url: "https://community.artauthority.net/aaservice.asp?action=artlist&lid=\(id)", context: privateMOC) { (works) in
                completion()
            }
        }
    }
    /// Fetches works from web by Artist ID
    ///```
    ///coreAPI.downloadByArtistID(id: Int32)
    ///```
    ///Once finished, populates CoreData with works.
    func downloadWorksByArtistID(id: Int32, completion: @escaping () -> Void) {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = TheModel.sharedInstance.persistenceManager.context
        privateMOC.perform {
            let parser = WorkParser()
            parser.parseFeed(url: "https://community.artauthority.net/aaservice.asp?action=artlist&aid=\(id)", context: privateMOC) { (works) in
                completion()
            }
        }
    }
    /// Downloads Image for a given work
    ///```
    ///coreAPI.downloadWorkImage(work: work) { (data) in }
    ///```
    /// Returns an image inside of a completion.
    func downloadWorkImage(work: Work, completion: @escaping (_ image: NSData?) -> Void){
        let theURL = URL(string: work.imagePath ?? "")!
        let request = URLRequest(url: theURL)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print("error")
                return
            }
            DispatchQueue.main.async {
                if(self.setWorkImage(work: work, data: data! as NSData)){
                    completion(data as NSData? ?? nil)
                } else {
                    completion(nil)
                }
            }
            
        }
        task.resume()
    }
    /// Downloads Thumbnail for a given work
    ///```
    ///coreAPI.downloadWorkThumnail(work: work) { (data) in }
    ///```
    /// Returns an image inside of a completion.
    func downloadWorkThumbnail(work: Work, completion: @escaping (_ image: NSData?) -> Void){
        let theURL = URL(string: work.thumbnailImagePath ?? "")!
        let request = URLRequest(url: theURL)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if error != nil{
                print("error")
                return
            }
            DispatchQueue.main.async {
                if(self.setWorkThumbnail(work: work, data: data! as NSData)){
                    completion(data as! NSData)
                } else {
                    completion(nil)
                }
            }
            
        }
        task.resume()
    }
    
    /// Sets work image
    private func setWorkImage(work: Work, data: NSData ) -> Bool{
        work.imageFile = data
        return true
    }
    /// Sets work Thumnail
    private func setWorkThumbnail(work: Work, data: NSData ) -> Bool{
        work.thumbnailFile = data
        return true
    }
    /// Toggles Buyable images only
    ///```
    ///coreAPI.toggleBuyable()
    ///```
    /// If this is toggled, program will disaply all works in database, by default only buyable will show.
    func toggleBuyable() {
        self.displayBuyableOnly = !self.displayBuyableOnly
    }
    
    /// saves current state of program in core data.
    func save() {
        TheModel.sharedInstance.persistenceManager.save()
    }
}
