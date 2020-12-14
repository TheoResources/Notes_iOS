//
//  ViewController.swift
//  Notes
//
//  Created by Michal Matlosz on 07/12/2020.
//
/*
 Aplikacja z notatkami
 
 TODO:
 - tagi notatki,
 - sortowanie po tagach
 
 */

import UIKit

class ViewController: UIViewController {
    
    static let sectionName = "Notes"
    static let cellHeight: CGFloat = 50
    static let reloadNotesNotification = Notification.Name("refreshNotes")
    let sortTextColorSelected = UIColor(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
    let sortTextColorDeselected = UIColor(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 0.5)
    
    
    var notesTableView: UITableView!
    var sortByEditedDate: UIButton!
    var sortByText: UIButton!
    var filterByPhotos: UIButton!
    
    var sortedByEditedDate: Bool = true
    var sortedByText: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationOfChangedNotes(notification:)), name: ViewController.reloadNotesNotification, object: nil)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(openAddNote))
        
        setupViews()
        setConstraints()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        sortByEditedDate = UIButton()
        sortByEditedDate.setTitle("Date \u{25BC}", for: .normal)
        sortByEditedDate.setTitleColor(sortTextColorSelected, for: .normal)
        sortByEditedDate.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sortByEditedDate.translatesAutoresizingMaskIntoConstraints = false
        sortByEditedDate.addTarget(self, action: #selector(sortByEditedDate(_:)), for: .touchUpInside)
        sortByEditedDate.contentHorizontalAlignment = .left
        view.addSubview(sortByEditedDate)
        
        sortByText = UIButton()
        sortByText.setTitle("Text \u{25BC}", for: .normal)
        sortByText.setTitleColor(sortTextColorDeselected, for: .normal)
        sortByText.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sortByText.translatesAutoresizingMaskIntoConstraints = false
        sortByText.addTarget(self, action: #selector(sortByText(_:)), for: .touchUpInside)
        view.addSubview(sortByText)
        
        filterByPhotos = UIButton()
        filterByPhotos.setTitle("With photos \u{25CB}", for: .normal)
        filterByPhotos.setTitle("With photos \u{25CF}", for: .selected)
        filterByPhotos.setTitleColor(sortTextColorDeselected, for: .normal)
        filterByPhotos.setTitleColor(sortTextColorSelected, for: .selected)
        
        filterByPhotos.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        filterByPhotos.translatesAutoresizingMaskIntoConstraints = false
        filterByPhotos.addTarget(self, action: #selector(filterByPhotos(_:)), for: .touchUpInside)
        filterByPhotos.contentHorizontalAlignment = .right
        view.addSubview(filterByPhotos)
        
        notesTableView = UITableView()
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        notesTableView.dataSource = self
        notesTableView.delegate = self
        notesTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "noteCellId")
        notesTableView.tableFooterView = UIView(frame: CGRect.zero)
        view.addSubview(notesTableView)
    }
    
    @objc func onNotificationOfChangedNotes(notification:Notification) {
        notesTableView.reloadData()
    }
    
    @IBAction func filterByPhotos(_ sender: UIButton) {
        sender.isSelected.toggle()
        if (sender.isSelected) {
            NotesStorage.filterByPhotos(withPhotos: true)
            notesTableView.reloadData()
        } else {
            NotesStorage.filterByPhotos(withPhotos: false)
            notesTableView.reloadData()
        }
    }
    
    @IBAction func sortByText(_ sender: UIButton) {
        sortByEditedDate.setTitleColor(sortTextColorDeselected, for: .normal)
        sortByText.setTitleColor(sortTextColorSelected, for: .normal)
        
        if (sortedByText) {
            sortByText.setTitle("Text \u{25B2}", for: .normal)
            NotesStorage.sortByText(sortedUp: sortedByText)
            notesTableView.reloadData()
            sortedByText = false
        } else {
            sortByText.setTitle("Text \u{25BC}", for: .normal)
            NotesStorage.sortByText(sortedUp: sortedByText)
            notesTableView.reloadData()
            sortedByText = true
        }
    }
    
    
    @IBAction func sortByEditedDate(_ sender: UIButton) {
        sortByEditedDate.setTitleColor(sortTextColorSelected, for: .normal)
        sortByText.setTitleColor(sortTextColorDeselected, for: .normal)
        
        if (sortedByEditedDate) {
            sortByEditedDate.setTitle("Date \u{25B2}", for: .normal)
            NotesStorage.sortByEditDate(sortedUp: sortedByEditedDate)
            notesTableView.reloadData()
            sortedByEditedDate = false
        } else {
            sortByEditedDate.setTitle("Date \u{25BC}", for: .normal)
            NotesStorage.sortByEditDate(sortedUp: sortedByEditedDate)
            notesTableView.reloadData()
            sortedByEditedDate = true
        }
    }
    
    @IBAction func openAddNote(_ sender: UIBarButtonItem) {
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
            sortByText.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
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
            notesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotesStorage.getNumberOfNotes()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCellId", for: indexPath) as! NoteTableViewCell
        cell.configure(for: NotesStorage.getNoteByIndex(index: indexPath.row))
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = (view as? UITableViewHeaderFooterView)
        headerView?.tintColor = sortTextColorSelected
        headerView?.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Self.sectionName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
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
