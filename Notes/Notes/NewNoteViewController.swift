//
//  NewNoteViewController.swift
//  Notes
//
//  Created by Michal Matlosz on 07/12/2020.
//

import Foundation
import UIKit

class NewNoteViewController: UIViewController {
    var note: Note = Note()
    
    var textNote: UITextView!
    var imageView: UIImageView?
    var addImage: UIButton!
    var imagesTableView: UITableView!
    var indexOfSelectedNote: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ViewController.sortTextColorSelected
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelNewNote))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveNewNote))

        setupViews()
        setConstraints()
    }
    
    func configure(index: Int, note: Note) {
        self.note = note
        self.indexOfSelectedNote = index
    }
    
    func setupViews() {
        textNote = UITextView()
        textNote.translatesAutoresizingMaskIntoConstraints = false
        textNote.text = note.text
        textNote.font = UIFont.systemFont(ofSize: 16)

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
        imagesTableView.register(NoteImageTableViewCell.self, forCellReuseIdentifier: "photoCellId")
        imagesTableView.tableFooterView = UIView()
        imagesTableView.separatorStyle = .singleLine
        view.addSubview(imagesTableView)
    }
    
    @IBAction func cancelNewNote(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNewNote(_ sender: UIBarButtonItem) {
        note.lastEditedTimeStamp = Date().timeIntervalSince1970
        note.text = textNote.text
        if let index = indexOfSelectedNote {
            NotesStorage.updateNoteAtIndex(index: index, note: note)
        } else {
            NotesStorage.addNote(note: note)
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
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            textNote.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textNote.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textNote.heightAnchor.constraint(equalToConstant: 100),
            textNote.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            addImage.topAnchor.constraint(equalTo: textNote.bottomAnchor, constant: 10),
            addImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            addImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            addImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
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
