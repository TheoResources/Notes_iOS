//
//  Note.swift
//  Notess
//
//  Created by Michal Matlosz on 07/12/2020.
//

import Foundation
import UIKit

struct Note {
    var text: String
    var lastEditedTimeStamp: TimeInterval
    var photos: [UIImage]
    
    init() {
        self.text = ""
        self.photos = []
        self.lastEditedTimeStamp = 0
    }
}
