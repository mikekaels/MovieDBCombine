//
//  MoviePersistence+CoreDataProperties.swift
//  
//
//  Created by Santo Michael on 08/02/24.
//
//

import Foundation
import CoreData


extension MoviePersistence {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviePersistence> {
        return NSFetchRequest<MoviePersistence>(entityName: "MoviePersistence")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var year: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var title: String?
    @NSManaged public var image: Data?

}
