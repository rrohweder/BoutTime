//
//  Plist.swift
//  BoutTime
//
//  Created by Roger Rohweder on 1/4/17.
//  Copyright © 2017 Roger Rohweder. All rights reserved.
//

import Foundation

enum PlistImportError: Error {
    case invalidResource(resourceName: String)
    case conversionFailure(resourceName: String)
}

// read/parse event data from plist-format data file into a collection
class PlistImporter {    
    static func importDictionaries(fromFile name: String, ofType type: String) throws -> [[String: AnyObject]] { // a type method
        guard let path = Bundle.main.path(forResource: name, ofType: type) else {
            throw PlistImportError.invalidResource(resourceName: name)
        }
        guard let arrayOfDictionaries = NSArray.init(contentsOfFile: path) as? [[String: AnyObject]] else {
            throw PlistImportError.conversionFailure(resourceName: name)
        }
        return arrayOfDictionaries
    }
}

