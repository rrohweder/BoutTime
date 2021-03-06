//
//  Events.swift
//  BoutTime
//
//  Created by Roger Rohweder on 12/30/16.
//  Copyright © 2016 Roger Rohweder. All rights reserved.
//

import Foundation
import GameKit

protocol OrderedEvents {
    var event: String { get set }
    var year: Int { get set }
    // could have included var url: String? { get set }
    // but decided to keep this protocol more generic and leave it out
    
    func isOrdered(event1: EventData, event2: EventData) -> Bool
}

struct EventData: OrderedEvents {
    var event: String
    var year: Int
    var url: String
    
    func isOrdered(event1: EventData, event2: EventData) -> Bool {
        return (event1.year >= event2.year)
    }
}

enum EventError:Error {
    case MissingEvent(String)
    case MissingYear(String)
}

class Events {
    
    var vanillaData: [[String:AnyObject]]
    var allEvents: [EventData]
    var eventStruct = EventData(event: "unknown", year: 1900, url: "unknown")
    var eventSet: [EventData]
    
    init() {
        vanillaData = []
        allEvents = []

        eventSet = [
            // initializing w/ dummy data for easy testing
            EventData(event: "Event A", year: 2000, url: ""),
            EventData(event: "Event B", year: 1990, url: ""),
            EventData(event: "Event C", year: 2010, url: "http://www.ebscohost.com/novelist"),
            EventData(event: "Event D", year: 2015, url: "")
        ]
    }
    
    // load event data into array of structs
    // if we can't read the file at all, fatalerror exit.
    // each input record is required to have the event text and year it occurred.
    // running into one, or a few, that don't have event and/or year is fine - 
    // load the rest, but we shouldn't launch the game if we don't have at least
    // 20 valid events, or we should fatalerror exit.
    
    func loadAllEvents(inputFile: String, fileType: String) throws -> [EventData] {
        var inputRow = 0
        var badrecords = 0
        
        do {
            let vanillaArray = try PlistImporter.importDictionaries(fromFile: inputFile, ofType: fileType)
            vanillaData = vanillaArray
        } catch let error {
            fatalError("\(error)")
        }
        for dict in vanillaData {
            inputRow += 1

            // for this exercise, event and year are required, url is not.
            // and I don't want to throw an error when just a few records 
            // are bad -- only when too many are bad. Just log the bad ones.
            if dict["event"] != nil {
                eventStruct.event = dict["event"] as! String
                if dict["year"] != nil {
                    eventStruct.year = dict["year"] as! Int
                    if dict["url"] != nil {
                        eventStruct.url = dict["url"] as! String
                    }
                    allEvents.append(eventStruct)
                } else {
                    // report bad row
                    print("Missing year, data input row \(inputRow)")
                    badrecords += 1
                }
            } else {
                print("Missing event, data input row \(inputRow)")
                badrecords += 1
            }
            if ((vanillaData.count - badrecords) < 20) {
                fatalError("not enough good records from input file to play")
            }
        }
        return allEvents
    }
    
    // return 4 unique events structs
    func refreshEventSet() {
        var randEventIndex: Int
        var alreadyUsed:[Int] = []
        for i in 0...eventSet.count - 1 {
            repeat {
                // randomIndex = gen rand int
                randEventIndex = GKRandomSource.sharedRandom().nextInt(upperBound: allEvents.count - 1)

            } while (alreadyUsed.contains(randEventIndex))
            alreadyUsed.append(randEventIndex)
            eventSet[i] = allEvents[randEventIndex]
        }
 
    }
    
    func swapEvents(swapEvent: Int, withEvent: Int) {
        let holdEvent = eventSet[swapEvent]
        eventSet[swapEvent] = eventSet[withEvent]
        eventSet[withEvent] = holdEvent
    }
    
    func eventsInCorrectOrder() -> Bool {
         if eventSet[0].isOrdered(event1: eventSet[0],event2: eventSet[1]) &&
            eventSet[0].isOrdered(event1: eventSet[1], event2: eventSet[2]) &&
            eventSet[0].isOrdered(event1: eventSet[2], event2: eventSet[3]) {
            return true
        } else {
            return false
        }
    }
    
}
