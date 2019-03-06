//
//  workParser.swift
//  1000Museums
//
//  Created by Brian Terry on 1/29/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import Foundation
import CoreData
class WorkParser: NSObject, XMLParserDelegate {
    private var works: [Work] = []
    private var context: NSManagedObjectContext?
    private var currentElement = ""
     private var currentCaption: String = ""
     private var currentArtistWikiURL: String = ""
     private var currentArtistID: Int32 = 0
     private var currentBuyURL: String = ""
     private var currentName: String = ""
     private var currentYear: Int32 = 0
     private var currentImagePath: String = ""
     private var currentArtist: String = ""
     private var currentHeight: Double = 0
     private var currentDimensions: String = ""
     private var currentYear2: Int32 = 0
     private var currentID: Int32 = 0
     private var currentLocationID: Int32 = 0
     private var currentThumbnailURL: String = ""
     private var currentWikiURL: String = ""
     private var currentWidth: Double = 0
     private var currentSortDate: Int32 = 0
     private var currentPublicDomain: Int32 = 0
     private var currentMedium: String = ""
     private var currentLocationName: String = ""
    private var parserCompletionHandler: (([Work]) ->Void)?
    
    func parseFeed(url: String, context: NSManagedObjectContext, completionHandler: (([Work]) ->Void)?){
        self.context = context
        self.parserCompletionHandler = completionHandler
        let theURL = URL(string: url)!
        let request = URLRequest(url: theURL)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error ?? "Unknown Error")
                return
            }
            //parse the data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
        
    }
    // MARK - XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "Work" {
             currentCaption = ""
             currentArtistWikiURL = ""
             currentArtistID = 0
             currentBuyURL = ""
             currentName = ""
             currentYear = 0
             currentImagePath = ""
             currentArtist  = ""
             currentHeight = 0
             currentDimensions = ""
             currentYear2 = 0
             currentID = 0
             currentLocationID = 0
             currentThumbnailURL = ""
             currentWikiURL = ""
             currentWidth = 0
             currentSortDate = 0
             currentPublicDomain = 0
             currentMedium = ""
             currentLocationName = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "Caption": currentCaption += string
        case "ArtistWikiURL":currentArtistWikiURL += string
        case "ArtistID":currentArtistID = Int32(string) ?? 0
        case "BuyUrl":currentBuyURL += string
        case "Name":currentName += string
        case "Year":currentYear = Int32(string) ?? 0
        case "ImagePath": currentImagePath += string
        case "Artist": currentArtist  += string
        case "Height": currentHeight = Double(string) ?? 0
        case "Dimensions": currentDimensions += string
        case "Year2": currentYear2 = Int32(string) ?? 0
        case "ID": currentID = Int32(string) ?? 0
        case "LocationID": currentLocationID = Int32(string) ?? 0
        case "Thumbnail": currentThumbnailURL += string
        case "WikiURL": currentWikiURL += string
        case "Width": currentWidth = Double(string) ?? 0
        case "SortDate":currentSortDate = Int32(string) ?? 0
        case "PublicDomain":currentPublicDomain = Int32(string) ?? 0
        case "Medium":currentMedium += string
        case "LocationName": currentLocationName += string
        default: break
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Work" {
            if(currentID != 0 && currentArtistID != 0 && currentThumbnailURL != "" && currentImagePath != ""){
                let work = Work(context: TheModel.sharedInstance.persistenceManager.context)
                  work.caption = currentCaption
                  work.artistWikiURL = currentArtistWikiURL
                  work.artistID = currentArtistID
                  work.buyURL = currentBuyURL
                  work.name = currentName
                  work.year = currentYear
                  work.imagePath = currentImagePath
                  work.artist = currentArtist
                  work.height = currentHeight
                  work.dimensions = currentDimensions
                  work.year2 = currentYear2
                  work.id = currentID
                  work.locationID = currentLocationID
                  work.thumbnailImagePath = currentThumbnailURL
                  work.wikiURL = currentWikiURL
                  work.width = currentWidth
                  work.sortDate = currentSortDate
                  work.publicDomain = currentPublicDomain
                  work.medium = currentMedium
                  work.locationName = currentLocationName
                self.works.append(work)
            }
        }
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        do {
            try context!.save()
        } catch {
            fatalError("Failure to save context \(error)")
        }
        parserCompletionHandler?(works)
    }
    func parser(_ parser: XMLParser, parseErrorOccurredparseError: Error) {
        do {
            try context!.save()
        } catch {
            fatalError("Failure to save context \(error)")
        }
    }
}
