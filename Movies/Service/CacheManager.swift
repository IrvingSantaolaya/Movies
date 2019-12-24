//
//  CacheService.swift
//  Movies
//
//  Created by Irving Martinez on 2/28/19.
//  Copyright © 2019 Irving Martinez. All rights reserved.
//

import Foundation

struct CacheManager {
    
    static var imageDictionary = [String:Data]()
    static func saveImageData(_ url:String ,_ data:Data) {
        
        // Saving the image data to dictionary
        imageDictionary[url] = data
        
    }
    
    static func retrieveImageData(_ url:String) -> Data? {
        
        // Passback the data associated with the key
        return imageDictionary[url]
        
    }
}
