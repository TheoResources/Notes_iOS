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
    
    var notesTableView: UITableView!

    let note1 = Note(text: "note1")
    let note2 = Note(text: "note2")
    let note3 = Note(text: "note3")
    
    var notes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notes = [note1, note2, note3]
        title = "Notes"
        view.backgroundColor = .white
        setupViews()
        setConstraints()
    }

    func setupViews() {
        notesTableView = UITableView()
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        notesTableView.dataSource = self
        notesTableView.delegate = self
        notesTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "id")
        notesTableView.tableFooterView = UIView(frame: CGRect.zero)
        view.addSubview(notesTableView)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            notesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            notesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! NoteTableViewCell
        cell.configure(for: notes[indexPath.row])
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
}

