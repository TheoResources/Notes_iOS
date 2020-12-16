//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Michal Matlosz on 07/12/2020.
//

import UIKit

class NoteTableViewCell: UITableViewCell {
    
    var shortText: UILabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        shortText.translatesAutoresizingMaskIntoConstraints = false
        shortText.font = .systemFont(ofSize: 16)
        contentView.addSubview(shortText)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for note: Note)  {
        shortText.text = note.text
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            shortText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shortText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shortText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            shortText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
}
