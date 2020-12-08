//
//  ViewController.swift
//  Notess
//
//  Created by Michal Matlosz on 07/12/2020.
//
/*
 Aplikacja z notatkami
 - ViewController z listą notatek, możliwość dodania, swipe do usunięcia. tableView można sortować po dacie edycji, alfabetycznie, po tagach, można odfiltrować tylko te notatki które mają zdjęcia
 - ViewController ze szczegółami - tableView z sekcjami - 1 sekcja z treścią, 2 sekcja z listą dodanych zdjęć. Z tego VC możliwość edycji tekstu i dodania/usunięcia/podglądu zdjęć. Możliwość tagowania notatek
 
 
 
 */

import UIKit

class ViewController: UIViewController {
    
    static let reloadNotesNotification = Notification.Name("refreshNotes")
    
    var notesTableView: UITableView!
    var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: ViewController.reloadNotesNotification, object: nil)
        
        view.backgroundColor = .white
        setupViews()
        setConstraints()
    }
    
    @objc func onNotification(notification:Notification) {
        notesTableView.reloadData()
    }
    
    func setupViews() {
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
        addButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        view.addSubview(addButton)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let newNote = NewNoteViewController()
        newNote.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNewNote))
        let navigationVC = UINavigationController(rootViewController: newNote)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
        
    }
    
    @IBAction func cancelNewNote(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            notesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
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
        return NotesStorage.getNotes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! NoteTableViewCell
        cell.configure(for: NotesStorage.getNoteByIndex(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Notes"
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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

}

