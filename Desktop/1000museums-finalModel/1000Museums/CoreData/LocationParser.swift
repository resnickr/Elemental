//
//  locationParser.swift
//  1000Museums
//
//  Created by Brian Terry on 1/29/19.
//  Copyright © 2019 RaiderSoft. All rights reserved.
//

import Foundation
import CoreData
class LocationParser: NSObject, XMLParserDelegate {
    private var locations: [Location] = []
    private var context: NSManagedObjectContext?
    private var currentElement = ""
     private var currentName: String = ""
     private var currentLatitude: Double = 0
     private var currentWorkCount: Int32 = 0
     private var currentID: Int32 = 0
     private var currentPhone: String = ""
     private var currentURL: String = ""
     private var currentWiki_URL: String = ""
     private var currentAddress: String = ""
     private var currentLongitude: Double = 0
     private var currentCity: String = ""
     private var currentCountry: String = ""
    private var parserCompletionHandler: (([Location]) ->Void)?
    
    func parseFeed(url: String, context: NSManagedObjectContext, completionHandler: (([Location]) ->Void)?){
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
        if currentElement == "Location" {
             currentName = ""
             currentLatitude = 0
             currentWorkCount  = 0
             currentID = 0
             currentPhone = ""
             currentURL = ""
             currentWiki_URL = ""
             currentAddress = ""
             currentLongitude = 0
             currentCity = ""
             currentCountry = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "ID": currentID = Int32(string) ?? 0
        case "Name": currentName += string
        case "Latitude": currentLatitude = Double(string) ?? 0
        case "WorkCount": currentWorkCount = Int32(string) ?? 0
        case "Phone": currentPhone += string
        case "URL": currentURL += string
        case "WIKI_URL": currentWiki_URL += string
        case "Address": currentAddress += string
        case "Longitude": currentLongitude = Double(string) ?? 0
        case "City": currentCity += string
        case "Country": currentCountry += string
        default: break
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Location" {
            if (currentWorkCount > 0 && currentID != 0 && currentURL != "") {
                let location = Location(context: self.context!)
                   location.address = currentAddress
                    location.city = currentCity
                    location.country = currentCountry
                    location.id = currentID
                    location.latitude = currentLatitude
                    location.longitude = currentLongitude
                    location.name = currentName
                    location.phone = currentPhone
                    location.url = currentURL
                    location.wiki_url = currentWiki_URL
                    location.workCount = currentWorkCount
                    self.locations.append(location)
            }
        }
    }
    func parserDidEndDocument(_ parser: XMLParser) {
        do {
            try context!.save()
        } catch {
            fatalError("Failure to save context \(error)")
        }
        parserCompletionHandler!(locations)
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        do {
            try context!.save()
        } catch {
            fatalError("Failure to save context \(error)")
        }
        parserCompletionHandler!(locations)
    }
}
