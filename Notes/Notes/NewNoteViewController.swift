//
//  NewNoteViewController.swift
//  Notes
//
//  Created by Michal Matlosz on 07/12/2020.
//

import Foundation
import UIKit
import CoreData

protocol NewNoteDelegate: class {
    func didAddNewNote()
}

class NewNoteViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var note: Note!
    
    var photosOfNote: [SingleImage] = []
    
    var textNote: UITextView = UITextView()
    var imageView: UIImageView?
    var addImageButton: UIButton = UIButton()
    var imagesTableView: UITableView = UITableView()
    
    weak var delegate: NewNoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = NotesViewController.sortTextColorSelected
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewNoteTap))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewNoteTap))

        setupViews()
        setConstraints()
        fetchPhotos()
    }
    
    func configure(note: Note) {
        self.note = note
    }
    
    func setupViews() {
        textNote.translatesAutoresizingMaskIntoConstraints = false
        textNote.text = note?.text ?? ""
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
    
    private func fetchPhotos() {
        do {
            let request = SingleImage.fetchRequest() as NSFetchRequest<SingleImage>
            let predicate = NSPredicate(format: "ANY ofNote == %@", self.note)
            request.predicate = predicate
            self.photosOfNote = try context.fetch(request)
            DispatchQueue.main.async {
                self.imagesTableView.reloadData()
            }
        }
        catch {
        }
    }
    
    @objc func cancelNewNoteTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveNewNoteTap() {
        if let editedOrNewNote = self.note {
            editedOrNewNote.lastEditedTimeStamp = Date().timeIntervalSince1970
            editedOrNewNote.text = textNote.text
            do {
                try self.context.save()
            }
            catch {
                
            }
            delegate?.didAddNewNote()
        }
        
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
        
        let singleImage = SingleImage(context: context)
        singleImage.img = image.jpegData(compressionQuality: 1.0)
        self.note.addToImg(singleImage)
        do {
            try self.context.save()
        } catch {
        }
        self.fetchPhotos()
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewNoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photosOfNote.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellId", for: indexPath) as! NoteImageTableViewCell
        
        if let img = self.photosOfNote[indexPath.row].img {
            cell.configure(for: UIImage(data: img)!) //TODO pozbyc sie !
        }
        
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
        if let img = self.photosOfNote[indexPath.row].img {
            photoViewController.setImage(image: UIImage(data: img)!) //TODO pozbyc sie ! oraz image zawsze powinien byc dostepny
        }
        present(navigationVC, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let imageToRemove = self.photosOfNote[indexPath.row]
            self.context.delete(imageToRemove)
            do {
                try self.context.save()
            } catch {
            }
            self.fetchPhotos()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
