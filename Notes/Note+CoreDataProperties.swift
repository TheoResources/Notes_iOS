//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by Michal Matlosz on 22/12/2020.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: String?
    @NSManaged public var lastEditedTimeStamp: Double
    @NSManaged public var text: String?
    @NSManaged public var img: NSSet?
    
    public var imgArray: [SingleImage] {
        let set = img as? Set<SingleImage> ?? []
        return Array(set)
    }

}

// MARK: Generated accessors for img
extension Note {

    @objc(addImgObject:)
    @NSManaged public func addToImg(_ value: SingleImage)

    @objc(removeImgObject:)
    @NSManaged public func removeFromImg(_ value: SingleImage)

    @objc(addImg:)
    @NSManaged public func addToImg(_ values: NSSet)

    @objc(removeImg:)
    @NSManaged public func removeFromImg(_ values: NSSet)

}

extension Note : Identifiable {

}
