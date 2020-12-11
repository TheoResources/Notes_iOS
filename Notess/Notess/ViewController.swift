//
//  ViewController.swift
//  Notess
//
//  Created by Michal Matlosz on 07/12/2020.
//
/*
 Aplikacja z notatkami
 
 TODO:
 - tagi notatki,
 - podglad zdjecia
 - odfiltrowac notatki tylko ze zdjeciem
 - sortowanie po tagach
 
 
 
 */

import UIKit

class ViewController: UIViewController {
    
    static let sectionName = "Notes"
    static let cellHeight: CGFloat = 50
    static let reloadNotesNotification = Notification.Name("refreshNotes")
    
    var notesTableView: UITableView!
    var addButton: UIButton!
    var sortByEditedDate: UIButton!
    var sortByText: UIButton!
    var filterByPhotos: UIButton!
    
    var sortedByEditedDate: Bool = true
    var sortedByText: Bool = false
    var filteredByPhotos: Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: ViewController.reloadNotesNotification, object: nil)
        
        setupViews()
        setConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        sortByEditedDate = UIButton()
        sortByEditedDate.setTitle("Date UP", for: .normal)
        sortByEditedDate.setTitleColor(.black, for: .normal)
        sortByEditedDate.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sortByEditedDate.layer.borderWidth = 1
        sortByEditedDate.layer.borderColor = UIColor.black.cgColor
        sortByEditedDate.layer.backgroundColor = UIColor.gray.cgColor
        sortByEditedDate.translatesAutoresizingMaskIntoConstraints = false
        sortByEditedDate.addTarget(self, action: #selector(sortByEditedDate(_:)), for: .touchUpInside)
        view.addSubview(sortByEditedDate)
        
        sortByText = UIButton()
        sortByText.setTitle("Text UP", for: .normal)
        sortByText.setTitleColor(.black, for: .normal)
        sortByText.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sortByText.layer.borderWidth = 1
        sortByText.layer.borderColor = UIColor.black.cgColor
        sortByText.translatesAutoresizingMaskIntoConstraints = false
        sortByText.addTarget(self, action: #selector(sortByText(_:)), for: .touchUpInside)
        view.addSubview(sortByText)
        
        filterByPhotos = UIButton()
        filterByPhotos.setTitle("With photos", for: .normal)
        filterByPhotos.setTitleColor(.black, for: .normal)
        filterByPhotos.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        filterByPhotos.layer.borderWidth = 1
        filterByPhotos.layer.borderColor = UIColor.black.cgColor
        filterByPhotos.translatesAutoresizingMaskIntoConstraints = false
        filterByPhotos.addTarget(self, action: #selector(filterByPhotos(_:)), for: .touchUpInside)
        view.addSubview(filterByPhotos)
        
        notesTableView = UITableView()
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        notesTableView.dataSource = self
        notesTableView.delegate = self
        notesTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "id")
        notesTableView.tableFooterView = UIView(frame: CGRect.zero)
        view.addSubview(notesTableView)
        
        addButton = UIButton()
        addButton.setImage(.add, for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(openAddNote(_:)), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    @objc func onNotification(notification:Notification) {
        notesTableView.reloadData()
    }
    
    @IBAction func filterByPhotos(_ sender: UIButton) {
        if (filteredByPhotos) {
            filterByPhotos.layer.backgroundColor = UIColor.white.cgColor
            NotesStorage.filterByPhotos(withPhotos: false)
            filteredByPhotos = false
            notesTableView.reloadData()
        } else {
            filterByPhotos.layer.backgroundColor = UIColor.gray.cgColor
            NotesStorage.filterByPhotos(withPhotos: true)
            filteredByPhotos = true
            notesTableView.reloadData()
        }
    }
    
    @IBAction func sortByText(_ sender: UIButton) {
        sortByEditedDate.layer.backgroundColor = UIColor.white.cgColor
        sortByText.layer.backgroundColor = UIColor.gray.cgColor

        if (sortedByText) {
            sortByText.setTitle("Text DN", for: .normal)
            NotesStorage.sortByText(sortedUp: sortedByText)
            notesTableView.reloadData()
            sortedByText = false
        } else {
            sortByText.setTitle("Text UP", for: .normal)
            NotesStorage.sortByText(sortedUp: sortedByText)
            notesTableView.reloadData()
            sortedByText = true
        }
    }
    
    
    @IBAction func sortByEditedDate(_ sender: UIButton) {
        sortByEditedDate.layer.backgroundColor = UIColor.gray.cgColor
        sortByText.layer.backgroundColor = UIColor.white.cgColor
        
        if (sortedByEditedDate) {
            sortByEditedDate.setTitle("Date DN", for: .normal)
            NotesStorage.sortByEditDate(sortedUp: sortedByEditedDate)
            notesTableView.reloadData()
            sortedByEditedDate = false
        } else {
            sortByEditedDate.setTitle("Date UP", for: .normal)
            NotesStorage.sortByEditDate(sortedUp: sortedByEditedDate)
            notesTableView.reloadData()
            sortedByEditedDate = true
        }
    }
    
    @IBAction func openAddNote(_ sender: UIButton) {
        let newNote = NewNoteViewController()
        let navigationVC = UINavigationController(rootViewController: newNote)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            sortByEditedDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sortByEditedDate.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            sortByText.leadingAnchor.constraint(equalTo: sortByEditedDate.trailingAnchor, constant: 10),
            sortByText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            filterByPhotos.leadingAnchor.constraint(equalTo: sortByText.trailingAnchor, constant: 10),
            filterByPhotos.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterByPhotos.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            notesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notesTableView.topAnchor.constraint(equalTo: sortByEditedDate.bottomAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: notesTableView.bottomAnchor, constant: 20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesStorage.getNumberOfNotes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! NoteTableViewCell
        cell.configure(for: NotesStorage.getNoteByIndex(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Self.sectionName
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Self.cellHeight
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            NotesStorage.removeNoteByIndex(index: indexPath.row)
            self.notesTableView.reloadData()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newNote = NewNoteViewController()
        newNote.configure(index: indexPath.row, note: NotesStorage.getNoteByIndex(index: indexPath.row))
        let navigationVC = UINavigationController(rootViewController: newNote)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
    
}
