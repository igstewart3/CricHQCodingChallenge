//
//  RSSParser.swift
//  CricHQCodingChallenge
//
//  Created by Ian Stewart on 09/10/2017.
//  Copyright © 2017 igstewart3. All rights reserved.
//

import Foundation

class RSSParser : NSObject, XMLParserDelegate {
    
    // MARK: Class variables
    var xmlParser: XMLParser!
    var currentElement = ""
    var foundCharacters = ""
    var currentData = [String:String]()
    var parsedData = [[String:String]]()
    var isHeader = true
    
    // MARK: Class functions
    /**
     Parses the RSS data from a given URL and reports back using the supplied completion handler.
     
     - parameters:
         - rssUrl: The URL to retrieve the RSS data from
         - completion: The completion handler for the async result
     */
    func parseRSSfromURL(rssUrl: URL, with completion: (Bool) -> ()) {
        let parser = XMLParser(contentsOf: rssUrl)
        parser?.delegate = self
        if let flag = parser?.parse() {
            // handle last item in feed
            parsedData.append(currentData)
            completion(flag)
        }
    }
    
    // MARK: XMLParserDelegate functions
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        // Only parse relevant tags
        currentElement = elementName
        if currentElement == "item" || currentElement == "entry" {
            
            if isHeader == false {
                
                parsedData.append(currentData)
                
            }
            
            isHeader = false
            
        }
        
        if isHeader == false {
            
            if currentElement == "media:thumbnail" || currentElement == "media:content" {
                
                foundCharacters += attributeDict["url"]!
                
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if isHeader == false {
            
            // Parse relevant items from xml
            if currentElement == "title" || currentElement == "link" || currentElement == "name" || currentElement == "icon" || currentElement == "author" || currentElement == "summary" || currentElement == "im:image" || currentElement == "im:price" || currentElement == "im:duration" || currentElement == "im:releaseDate" {
                
                foundCharacters += string
                foundCharacters = foundCharacters.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                
            }
            
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if !foundCharacters.isEmpty {
            
            // Add parsed entry to data and reset found characters
            foundCharacters = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
            currentData[currentElement] = foundCharacters
            foundCharacters = ""
            
        }
        
    }
    
}
