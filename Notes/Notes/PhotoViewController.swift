//
//  PhotoViewController.swift
//  Notes
//
//  Created by Michal Matlosz on 11/12/2020.
//

import UIKit

class PhotoViewController: UIViewController {

    var imageView: UIImageView = UIImageView()
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closePhotoViewTap))
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .black

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setImage(image: UIImage) {
        self.image = image
    }
    
    @objc func closePhotoViewTap() {
        dismiss(animated: true, completion: nil)
    }

}
