//
//  ViewController.swift
//  Notes
//
//  Created by Michal Matlosz on 07/12/2020.
//


import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let sectionName = "Notes"
    static let cellHeight: CGFloat = 50
    static let reloadNotesNotification = Notification.Name("refreshNotes")
    static let sortTextColorSelected = UIColor(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1)
    let sortTextColorDeselected = UIColor(red: 0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 0.5)
    let blackDownPointingTriangleUnicodeCharacter = "\u{25BC}"
    let blackUpPointingTriangleUnicodeCharacter = "\u{25B2}"
    let filterByPhotosOffTitle = "With photos \u{25CB}"
    let filterByPhotosOnTitle = "With photos \u{25CF}"
    
    var notesTableView: UITableView = UITableView()
    var sortByEditedDateButton: UIButton = UIButton()
    var sortByTextButton: UIButton = UIButton()
    var filterByPhotosButton: UIButton = UIButton()
    
    var sortedByEditedDate: Bool = true
    var sortedByText: Bool? = nil
    
    var withPhotosFilterIsEnabled: Bool = false
    
    var notes: [Note]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddNote))
        
        setupViews()
        setConstraints()
        
        fetchNotes()
        self.sortedByEditedDate = false
    }
    
    func fetchNotes() {
        do {
            let request = Note.fetchRequest() as NSFetchRequest<Note>
            
            if (withPhotosFilterIsEnabled) {
                let pred = NSPredicate(format: "ANY img != nil")
                request.predicate = pred
            }
            
            let sortByDate = NSSortDescriptor(key: "lastEditedTimeStamp", ascending: sortedByEditedDate)
            request.sortDescriptors = [sortByDate]
            
            if let sortedByText = sortedByText {
                let sortByTxt = NSSortDescriptor(key: "text", ascending: sortedByText)
                request.sortDescriptors = [sortByTxt, sortByDate]
            }
            
            self.notes = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.notesTableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
        
        sortByEditedDateButton.setTitle(getSortLabelText(labelSortName: "Date", isUp: false), for: .normal)
        sortByEditedDateButton.setTitleColor(NotesViewController.sortTextColorSelected, for: .normal)
        sortByEditedDateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sortByEditedDateButton.translatesAutoresizingMaskIntoConstraints = false
        sortByEditedDateButton.addTarget(self, action: #selector(sortByEditedDateTap), for: .touchUpInside)
        sortByEditedDateButton.contentHorizontalAlignment = .left
        view.addSubview(sortByEditedDateButton)
        
        sortByTextButton.setTitle(getSortLabelText(labelSortName: "Text", isUp: false), for: .normal)
        sortByTextButton.setTitleColor(sortTextColorDeselected, for: .normal)
        sortByTextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sortByTextButton.translatesAutoresizingMaskIntoConstraints = false
        sortByTextButton.addTarget(self, action: #selector(sortByTextTap), for: .touchUpInside)
        view.addSubview(sortByTextButton)
        
        filterByPhotosButton.setTitle(filterByPhotosOffTitle, for: .normal)
        filterByPhotosButton.setTitle(filterByPhotosOnTitle, for: .selected)
        filterByPhotosButton.setTitleColor(sortTextColorDeselected, for: .normal)
        filterByPhotosButton.setTitleColor(NotesViewController.sortTextColorSelected, for: .selected)
        
        filterByPhotosButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        filterByPhotosButton.translatesAutoresizingMaskIntoConstraints = false
        filterByPhotosButton.addTarget(self, action: #selector(filterByPhotosTap(_:)), for: .touchUpInside)
        filterByPhotosButton.contentHorizontalAlignment = .right
        view.addSubview(filterByPhotosButton)
        
        notesTableView.translatesAutoresizingMaskIntoConstraints = false
        notesTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: "noteCellId")
        notesTableView.dataSource = self
        notesTableView.delegate = self
        notesTableView.tableFooterView = UIView()
        notesTableView.separatorStyle = .singleLine
        view.addSubview(notesTableView)
    }
    
    @objc func filterByPhotosTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        if (sender.isSelected) {
            withPhotosFilterIsEnabled = true
            fetchNotes()
        } else {
            withPhotosFilterIsEnabled = false
            fetchNotes()
        }
    }
    
    @objc func sortByTextTap() {
        let sorted = sortedByText ?? true
        sortByEditedDateButton.setTitleColor(sortTextColorDeselected, for: .normal)
        sortByTextButton.setTitleColor(NotesViewController.sortTextColorSelected, for: .normal)
        sortByTextButton.setTitle(getSortLabelText(labelSortName: "Text", isUp: sorted), for: .normal)
        fetchNotes()
        sortedByText = !sorted
    }
    
    @objc func sortByEditedDateTap() {
        sortedByText = nil
        sortByEditedDateButton.setTitleColor(NotesViewController.sortTextColorSelected, for: .normal)
        sortByTextButton.setTitleColor(sortTextColorDeselected, for: .normal)
        sortByEditedDateButton.setTitle(getSortLabelText(labelSortName: "Date", isUp: sortedByEditedDate), for: .normal)
        fetchNotes()
        sortedByEditedDate = !sortedByEditedDate
    }
    
    @IBAction func openAddNote(_ sender: UIBarButtonItem) {
        let newNote = NewNoteViewController()
        newNote.delegate = self
        newNote.configure(note: Note(context: self.context), isNew: true)
        let navigationVC = UINavigationController(rootViewController: newNote)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
    
    func getSortLabelText(labelSortName: String, isUp: Bool) -> String {
        if (isUp) {
            return "\(labelSortName) \(blackUpPointingTriangleUnicodeCharacter)"
        }
        return "\(labelSortName) \(blackDownPointingTriangleUnicodeCharacter)"
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            sortByEditedDateButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sortByEditedDateButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            sortByTextButton.leadingAnchor.constraint(equalTo: sortByEditedDateButton.trailingAnchor, constant: 10),
            sortByTextButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            sortByTextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            filterByPhotosButton.leadingAnchor.constraint(equalTo: sortByTextButton.trailingAnchor, constant: 10),
            filterByPhotosButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            filterByPhotosButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            notesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            notesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            notesTableView.topAnchor.constraint(equalTo: sortByEditedDateButton.bottomAnchor, constant: 10),
            notesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfNotes = notes?.count ?? 0
        if numberOfNotes == 0 {
            tableView.setEmptyView(title: "You don't have any notes.", message: "Your notes will be in here.")
        } else {
            tableView.restore()
        }
        
        return numberOfNotes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCellId", for: indexPath) as! NoteTableViewCell
        let note = self.notes![indexPath.row]
        cell.configure(for: note)
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = (view as? UITableViewHeaderFooterView)
        headerView?.tintColor = NotesViewController.sortTextColorSelected
        headerView?.textLabel?.textColor = .white
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Self.sectionName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
}

extension NotesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Self.cellHeight
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            let noteToRemove = self.notes![indexPath.row]
            self.context.delete(noteToRemove)
            do {
                try self.context.save()
            }
            catch {
                
            }
            self.fetchNotes()
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newNote = NewNoteViewController()
        newNote.delegate = self
        let noteToEdit = self.notes![indexPath.row]
        newNote.configure(note: noteToEdit, isNew: false)
        let navigationVC = UINavigationController(rootViewController: newNote)
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
}

extension NotesViewController: NewNoteDelegate {
    func didAddNewNote() {
        fetchNotes()
    }
}

extension UITableView {
    
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)

        emptyView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])

        emptyView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor)
        ])

        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
    
}
