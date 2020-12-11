//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Michal Matlosz on 07/12/2020.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    var shortText: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        shortText = UILabel()
        shortText.translatesAutoresizingMaskIntoConstraints = false
        shortText.font = .systemFont(ofSize: 14)
        contentView.addSubview(shortText)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for note: Note)  {
        shortText.text = "\(note.text) -  \(note.lastEditedTimeStamp)"
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            shortText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            shortText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shortText.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
}
