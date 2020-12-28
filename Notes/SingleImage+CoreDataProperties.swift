//
//  SingleImage+CoreDataProperties.swift
//  Notes
//
//  Created by Michal Matlosz on 28/12/2020.
//
//

import Foundation
import CoreData


extension SingleImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SingleImage> {
        return NSFetchRequest<SingleImage>(entityName: "SingleImage")
    }

    @NSManaged public var photo: Data?
    @NSManaged public var thumbnail: Data?
    @NSManaged public var ofNote: Note?

}

extension SingleImage : Identifiable {

}
