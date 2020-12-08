//
//  NotesStorage.swift
//  Notess
//
//  Created by Michal Matlosz on 08/12/2020.
//

import Foundation

class NotesStorage {
    
    static var notes: [Note] = []
    
    init() {}
    
    static func addNote(note: Note) {
        Self.notes.append(note)
    }
    
    static func getNotes() -> [Note] {
        return Self.notes
    }
    
    static func getNumberOfNotes() -> Int {
        return Self.notes.count
    }
    
    static func getNoteByIndex(index: Int) -> Note {
        return Self.notes[index]
    }
    
    static func removeNoteByIndex(index: Int) {
        if (Self.notes.indices.contains(index) ) {
            Self.notes.remove(at: index)
        }
    }
}
