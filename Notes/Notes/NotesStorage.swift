//
//  NotesStorage.swift
//  Notes
//
//  Created by Michal Matlosz on 08/12/2020.
//

import Foundation

class NotesStorage {
    //TODO core data /sqlite
    private static var notesWithoutPhotos: [Note] = []
    private static var notesWithPhotos: [Note] = []
    
    private static var sortedByEditDate: Bool? = false
    private static var sortedByText: Bool? = nil
    
    static var displayableNotes: [Note] = []
    static var notesStorage: [String: Note] = [:]
    
    static var withPhotosEnabled: Bool = false
    
    init() {}
    
    static func addNote(note: Note) {
        notesStorage[note.id] = note
        prepareData()
    }
    
    static func updateNoteAtIndex(index: Int, note: Note) {
        Self.notesStorage[note.id] = note
        prepareData()
    }
    
    static func getNumberOfNotes() -> Int {
        return Self.displayableNotes.count
    }
    
    static func getNoteByIndex(index: Int) -> Note {
        return Self.displayableNotes[index]
    }
    
    static func removeNoteByIndex(index: Int) {
        if (Self.displayableNotes.indices.contains(index) ) {
            let note = Self.displayableNotes[index]
            Self.notesStorage.removeValue(forKey: note.id)
        }
        prepareData()
    }
    
    static func sortByEditDate(sortedUp: Bool) {
        Self.sortedByEditDate = sortedUp
        Self.sortedByText = nil
        prepareData()
    }
    
    static func sortByText(sortedUp: Bool) {
        Self.sortedByText = sortedUp
        Self.sortedByEditDate = nil
        prepareData()
    }
    
    static func filterByPhotos(withPhotos: Bool) {
        Self.withPhotosEnabled = withPhotos
        prepareData()
    }
    
    private static func prepareData() {
        if (Self.withPhotosEnabled) {
            Self.displayableNotes = Array(Self.notesStorage.values).filter { note in return note.photos.count > 0 }
        } else {
            Self.displayableNotes = Array(Self.notesStorage.values)
        }
        
        if let sortedData = Self.sortedByEditDate {
            if (sortedData) {
                Self.displayableNotes = Self.displayableNotes.sorted { $0.lastEditedTimeStamp > $1.lastEditedTimeStamp }
            } else {
                Self.displayableNotes = Self.displayableNotes.sorted { $0.lastEditedTimeStamp < $1.lastEditedTimeStamp }
            }
        }
        if let sortedData2 = Self.sortedByText {
            if (sortedData2) {
                Self.displayableNotes = Self.displayableNotes.sorted { $0.text > $1.text }
            } else {
                Self.displayableNotes = Self.displayableNotes.sorted { $0.text < $1.text }
            }
        }
        
    }
}
