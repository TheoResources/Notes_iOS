//
//  NewNoteViewController.swift
//  Notess
//
//  Created by Michal Matlosz on 07/12/2020.
//

import Foundation
import UIKit

class NewNoteViewController: UIViewController {
    var note: Note? = nil
    var textNote: UITextView!
    var imageView: UIImageView?
    var addImage: UIButton!
    var addedImages: [UIImage] = []
    var imagesTableView: UITableView!
    var text: String = ""
    var noteId: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNewNote))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveNewNote))
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        setupViews()
        setConstraints()
    }
    
    func configure(index: Int, note: Note?) {
        if let note = note {
            addedImages = note.photos
            text = note.text
            noteId = index
        } else {
            addedImages = []
            text = ""
            noteId = nil
        }
    }
    
    func setupViews() {
        textNote = UITextView()
        textNote.translatesAutoresizingMaskIntoConstraints = false
        textNote.text = text
        view.addSubview(textNote)
        
        addImage = UIButton()
        addImage.setTitle("Add photo", for: .normal)
        addImage.translatesAutoresizingMaskIntoConstraints = false
        addImage.addTarget(self, action: #selector(addPhoto(_:)), for: .touchUpInside)
        view.addSubview(addImage)
        
        imagesTableView = UITableView()
        imagesTableView.translatesAutoresizingMaskIntoConstraints = false
        imagesTableView.dataSource = self
        imagesTableView.delegate = self
        imagesTableView.register(NoteImageTableViewCell.self, forCellReuseIdentifier: "id2")
        view.addSubview(imagesTableView)
    }
    
    @IBAction func cancelNewNote(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNewNote(_ sender: UIBarButtonItem) {
        if let index = noteId {
            NotesStorage.updateNoteAtIndex(index: index, note: Note(text: textNote.text, lastEditedTimeStamp: Date().timeIntervalSince1970, photos: addedImages))
        } else {
            NotesStorage.addNote(note: Note(text: textNote.text, lastEditedTimeStamp: Date().timeIntervalSince1970, photos: addedImages))
        }
    
        NotificationCenter.default.post(name: ViewController.reloadNotesNotification, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc
    private func keyboardWillShow(_ sender: Notification) {
        //TODO?
        //https://medium.com/nickelfox/ios-swift-expandable-textview-with-placeholder-fca5ed2556f4
        //https://medium.com/@PaulWall43/how-to-raise-a-uitextfield-when-the-keyboard-shows-ccfa6553c911
    }
    
    @objc
    private func keyboardWillHide(_ sender: Notification) {
        //TODO?
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            textNote.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textNote.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textNote.heightAnchor.constraint(equalToConstant: 100),
            textNote.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            addImage.topAnchor.constraint(equalTo: textNote.bottomAnchor, constant: 10),
            addImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imagesTableView.topAnchor.constraint(equalTo: addImage.bottomAnchor, constant: 10),
            imagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imagesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension NewNoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }

        addedImages.append(image)
        imagesTableView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewNoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addedImages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id2", for: indexPath) as! NoteImageTableViewCell
        cell.configure(for: self.addedImages[indexPath.row])
        return cell
    }
}

extension NewNoteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected \(indexPath.row)")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            if (self.addedImages.indices.contains(indexPath.row) ) {
                self.addedImages.remove(at: indexPath.row)
            }
            
            self.imagesTableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

extension NewNoteViewController: UITextViewDelegate {
    
}
