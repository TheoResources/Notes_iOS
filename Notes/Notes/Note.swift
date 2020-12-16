//
//  Note.swift
//  Notes
//
//  Created by Michal Matlosz on 07/12/2020.
//

import Foundation
import UIKit

struct Note {
    var id: String
    var text: String
    var lastEditedTimeStamp: TimeInterval
    var photos: [UIImage]
    
    init() {
        self.id = UUID().uuidString
        self.text = ""
        self.photos = []
        self.lastEditedTimeStamp = 0
    }
    
    mutating func removePhotoByIndex(index: Int) {
        if (self.photos.indices.contains(index) ) {
            self.photos.remove(at: index)
        }
    }
}
