//
//  NoteImageTableViewCell.swift
//  Notes
//
//  Created by Michal Matlosz on 10/12/2020.
//
import UIKit

class NoteImageTableViewCell: UITableViewCell {
    
    var photoView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        photoView = UIImageView()
        photoView.contentMode = .scaleAspectFit
        photoView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(for image: UIImage)  {
        photoView.image = image
    }
        
    func setupConstraints() {
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoView.heightAnchor.constraint(equalToConstant: 60),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
