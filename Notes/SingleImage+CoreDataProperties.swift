//
//  SingleImage+CoreDataProperties.swift
//  Notes
//
//  Created by Michal Matlosz on 22/12/2020.
//
//

import Foundation
import CoreData


extension SingleImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SingleImage> {
        return NSFetchRequest<SingleImage>(entityName: "SingleImage")
    }

    @NSManaged public var img: Data
    @NSManaged public var ofNote: Note?

}

extension SingleImage : Identifiable {

}
