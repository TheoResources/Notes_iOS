//
//  NotesStorage.swift
//  Notes
//
//  Created by Michal Matlosz on 08/12/2020.
//

import Foundation

class NotesStorage {
    
    private static var notes: [Note] = []
    
    static var displayableNotes: [Note] = []
    
    static var withPhotosEnabled: Bool = false
    
    init() {}
    
    static func addNote(note: Note) {
        Self.notes.append(note)
        Self.displayableNotes = Self.notes
    }
    
    static func updateNoteAtIndex(index: Int, note: Note) {
        Self.notes[index] = note
        Self.displayableNotes = Self.notes
    }
    
    static func getNumberOfNotes() -> Int {
        return Self.displayableNotes.count
    }
    
    static func getNoteByIndex(index: Int) -> Note {
        return Self.displayableNotes[index]
    }
    
    static func removeNoteByIndex(index: Int) {
        if (Self.notes.indices.contains(index) ) {
            Self.notes.remove(at: index)
        }
        Self.displayableNotes = Self.notes
    }
    
    static func sortByEditDate(sortedUp: Bool) {
        if (sortedUp) {
            Self.notes = Self.notes.sorted { $0.lastEditedTimeStamp > $1.lastEditedTimeStamp }
        } else {
            Self.notes = Self.notes.sorted { $0.lastEditedTimeStamp < $1.lastEditedTimeStamp }
        }
        Self.displayableNotes = Self.notes
    }
    
    static func sortByText(sortedUp: Bool) {
        if (sortedUp) {
            Self.notes = Self.notes.sorted { $0.text > $1.text }
        } else {
            Self.notes = Self.notes.sorted { $0.text < $1.text }
        }
        Self.displayableNotes = Self.notes
    }
    
    static func filterByPhotos(withPhotos: Bool) {
        Self.withPhotosEnabled = withPhotos
        if (Self.withPhotosEnabled) {
            Self.displayableNotes = Self.notes.filter { note in return note.photos.count > 0 }
        } else {
            Self.displayableNotes = Self.notes
        }
    }
}
