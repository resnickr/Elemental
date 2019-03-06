//
//  theModel.swift
//  1000Museums
//
//  Created by Brian Terry on 1/27/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//


import Foundation
import CoreData
import UIKit

class TheModel {
    
    // variables to hold current location, artist and work and image
    var museumToDisplay : Location? = nil
    var artistToDisplay : Artist? = nil

    var locationWork : Work? = nil
    var artistWork : Work? = nil
    
    var imgToDisplay : UIImage? = nil
    
    // variables for arrays to hold artists list and locations list
    var museumArr : [Location] = []
    var artistArr : [Artist] = []
    
    // varables for arrays to hold actual artwork for each type of list
    var museumWorkArr : [Work] = []
    var artistWorkArr : [Work] = []
    
    // Creates a singleton, and intitializes Core Data Globally.
    static let sharedInstance = TheModel(persistenceManager:PersistenceManager.shared)
    let persistenceManager: PersistenceManager
    init(persistenceManager: PersistenceManager){
        self.persistenceManager = persistenceManager
    }
    let coreAPI: CoreAPI = CoreAPI()
    
    
    // Initilizes the database returns true with a completion if successful.
    func initProgram(completion: @escaping (_ didComplete: Bool) -> Void){
        coreAPI.initDatabase { (didComplete) in
            completion(didComplete)
        }
    }
    func getMuseums() -> [Location] {
        return coreAPI.retrieveAllLocations()
    }
    func getArtists() -> [Artist] {
        return coreAPI.retrieveAllArtists()
    }
    // this function must be a completion because the coreAPI retrieve works itself is asyncronous.
    func getWorksForLocation(id: Int32) -> [Work]{
        return coreAPI.retrieveWorksByLocationID(id: id)
    }
    func downloadWorksForLocation(id: Int32, completion: @escaping () -> Void) {
        coreAPI.downloadWorksByLocationID(id: id) {
            completion()
        }
    }
    func downloadWorksForArtist(id: Int32, completion: @escaping () -> Void) {
        coreAPI.downloadWorksByArtistID(id: id) {
            completion()
        }
    }
    func getWorksForArtist(id: Int32) -> [Work] {
        return coreAPI.retrieveWorksByArtistID(id: id)
    }
    // downloads an arrays worth of thumbnails.. currently I'm just downloading all of them. 20 to 30 at a time seems very fast. 
    func downloadWorkThumbnail(work: Work, completion: @escaping(_ image: NSData?) -> Void ){
            coreAPI.downloadWorkThumbnail(work: work) { (data) in
                    completion(data)
        }
    }
    func downloadFullImage(work: Work, completion: @escaping(_ image: NSData?) -> Void) {
        coreAPI.downloadWorkImage(work: work) { (data) in
            completion(data)
        }
    }
}



