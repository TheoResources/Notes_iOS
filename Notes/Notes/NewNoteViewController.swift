//
//  NewNoteViewController.swift
//  Notes
//
//  Created by Michal Matlosz on 07/12/2020.
// 

import Foundation
import UIKit
import CoreData
import Alamofire
import AlamofireImage

protocol NewNoteDelegate: class {
    func didAddNewNote()
}

class NewNoteViewController: UIViewController {
    
    let heightOfPhoto: CGFloat = 100.0
    let heigthOfPhotoCell: CGFloat = 120.0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var note: Note!
    
    var photosOfNote: [SingleImage] = []
    
    var textNote: UITextView = UITextView()
    var imageView: UIImageView?
    var addImageButton: UIButton = UIButton()
    var imagesTableView: UITableView = UITableView()
    var isNew : Bool = false
    
    weak var delegate: NewNoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelNewNoteTap))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNewNoteTap))
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTerminate), name: UIScene.didDisconnectNotification, object: nil)
        
        setupViews()
        setConstraints()
        fetchPhotos()
    }
    
    @objc func onTerminate() {
        removeNotSavedNote()
    }
    
    func configure(note: Note, isNew: Bool) {
        self.isNew = isNew
        self.note = note
    }
    
    func setupViews() {
        textNote.translatesAutoresizingMaskIntoConstraints = false
        textNote.text = note?.text ?? ""
        textNote.font = UIFont.systemFont(ofSize: 16)
        textNote.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        textNote.layer.borderColor = NotesViewController.sortTextColorSelected.cgColor

        textNote.layer.borderWidth = 1.0;
        textNote.layer.cornerRadius = 5.0;
        
        view.addSubview(textNote)
        
        addImageButton.setTitle("Add photo", for: .normal)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.setTitleColor(NotesViewController.sortTextColorSelected, for: .normal)
        addImageButton.setImage(UIImage(systemName: "camera"), for: .normal)
        addImageButton.imageEdgeInsets.left = -20
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
        removeNotSavedNote()
        dismiss(animated: true, completion: nil)
    }
    
    private func removeNotSavedNote() {
        if (isNew) {
            self.context.delete(self.note)
            do {
                try self.context.save()
            }
            catch {
                
            }
        }
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
            textNote.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            textNote.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            textNote.heightAnchor.constraint(equalToConstant: 150),
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
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        
        let background = DispatchQueue.global()
        background.async {
            
            let singleImage = SingleImage(context: self.context)
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            
            let size = CGSize(width: self.heightOfPhoto * image.size.width  / image.size.height, height: self.heightOfPhoto)
            let scaledImage = image.af.imageScaled(to: size)
            
            if let image = image.jpegData(compressionQuality: 1.0) {
                singleImage.photo = image
            }
            
            singleImage.thumbnail = scaledImage.pngData()
            self.note.addToImg(singleImage)
            
            do {
                try self.context.save()
            } catch {
            }
            
            self.fetchPhotos()
            DispatchQueue.main.async() {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension NewNoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.photosOfNote.count == 0 {
            tableView.setEmptyView(title: "You don't have any photos.", message: "Your photos will be in here.")
        } else {
            tableView.restore()
        }
        
        return self.photosOfNote.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellId", for: indexPath) as! NoteImageTableViewCell
        let photo = self.photosOfNote[indexPath.row].thumbnail
        if let image = UIImage(data: photo!) {
            cell.configure(for: image)
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
        let photo = self.photosOfNote[indexPath.row].photo
        if let image = UIImage(data: photo!) {
            photoViewController.setImage(image: image)
        }
        present(navigationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.heigthOfPhotoCell
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
