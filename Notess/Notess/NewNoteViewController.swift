//
//  NewNoteViewController.swift
//  Notess
//
//  Created by Michal Matlosz on 07/12/2020.
//

import Foundation
import UIKit

class NewNoteViewController: UIViewController {
    var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        
        setupViews()
        setConstraints()
    }
    
    func setupViews() {
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        view.addSubview(saveButton)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        NotesStorage.addNote(note: Note(text: "aaa"))
        NotificationCenter.default.post(name: ViewController.reloadNotesNotification, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
        ])
    }
}
