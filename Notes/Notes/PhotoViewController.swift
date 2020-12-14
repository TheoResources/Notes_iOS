//
//  PhotoViewController.swift
//  Notes
//
//  Created by Michal Matlosz on 11/12/2020.
//

import UIKit

class PhotoViewController: UIViewController {

    var imageView: UIImageView!
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.close, target: self, action: #selector(closePhotoView))
        
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .black

        imageView = UIImageView()
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
    
    @IBAction func closePhotoView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
