//
//  Photo+CoreDataProperties.swift
//  MeCoreDataTableView
//
//  Created by MB on 6/18/19.
//  Copyright © 2019 MB. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var author: String?
    @NSManaged public var mediaURL: String?
    @NSManaged public var tags: String?

}
