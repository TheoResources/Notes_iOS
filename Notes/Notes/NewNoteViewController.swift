//
//  NewNoteViewController.swift
//  Notes
//
//  Created by Michal Matlosz on 07/12/2020.
//

import Foundation
import UIKit

protocol NewNoteDelegate: class {
    func didAddNewNote()
}

class NewNoteViewController: UIViewController {
    var note: Note = Note()
    
    var textNote: UITextView = UITextView()
    var imageView: UIImageView?
    var addImageButton: UIButton = UIButton()
    var imagesTableView: UITableView = UITableView()
    var indexOfSelectedNote: Int? = nil
    
    weak var delegate: NewNoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = NotesViewController.sortTextColorSelected
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewNoteTap))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewNoteTap))

        setupViews()
        setConstraints()
    }
    
    func configure(index: Int, note: Note) {
        self.note = note
        self.indexOfSelectedNote = index
    }
    
    func setupViews() {
        textNote.translatesAutoresizingMaskIntoConstraints = false
        textNote.text = note.text
        textNote.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(textNote)
        
        addImageButton.setTitle("Add photo", for: .normal)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.addTarget(self, action: #selector(addPhotoTap), for: .touchUpInside)
        view.addSubview(addImageButton)
        
        imagesTableView.translatesAutoresizingMaskIntoConstraints = false
        imagesTableView.dataSource = self
        imagesTableView.delegate = self
        imagesTableView.register(NoteImageTableViewCell.self, forCellReuseIdentifier: "photoCellId")
        imagesTableView.tableFooterView = UIView()
        imagesTableView.separatorStyle = .singleLine
        view.addSubview(imagesTableView)
    }
    
    @objc func cancelNewNoteTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveNewNoteTap() {
        note.lastEditedTimeStamp = Date().timeIntervalSince1970
        note.text = textNote.text
        if let index = indexOfSelectedNote {
            NotesStorage.updateNoteAtIndex(index: index, note: note)
        } else {
            NotesStorage.addNote(note: note)
        }
    
        delegate?.didAddNewNote()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addPhotoTap() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            textNote.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textNote.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textNote.heightAnchor.constraint(equalToConstant: 100),
            textNote.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            addImageButton.topAnchor.constraint(equalTo: textNote.bottomAnchor, constant: 10),
            addImageButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addImageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            addImageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            imagesTableView.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 10),
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
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        self.note.photos.append(image)
        imagesTableView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewNoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.note.photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellId", for: indexPath) as! NoteImageTableViewCell
        cell.configure(for: self.note.photos[indexPath.row])
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
}

extension NewNoteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoViewController = PhotoViewController()
        let navigationVC = UINavigationController(rootViewController: photoViewController)
        navigationVC.modalPresentationStyle = .fullScreen
        photoViewController.setImage(image: note.photos[indexPath.row])
        present(navigationVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            self.note.removePhotoByIndex(index: indexPath.row)
            
            self.imagesTableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
