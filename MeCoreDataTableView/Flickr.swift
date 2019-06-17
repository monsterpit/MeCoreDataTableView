//
//  Flickr.swift
//  MeCoreDataTableView
//
//  Created by MB on 6/18/19.
//  Copyright © 2019 MB. All rights reserved.
//

import Foundation

struct Flickr : Codable{
    
    var items = [item]()
    
    struct item : Codable {
        
        var tags : String
        
        var media : m
        
        struct m : Codable{
            
            var m : String
            
        }
        
        var author : String
        
    }
    
}



