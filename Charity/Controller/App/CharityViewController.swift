//
//  CharityViewController.swift
//  Charity
//
//  Created by Al Stark on 05.12.2022.
//

import UIKit

class CharityViewController: UIViewController {
    
    private var photo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var qiwiLinkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        setupUI()
       
    }
    
    // MARK: - setupUI

    private func setupUI() {
        setupPhoto()
        setupNameLabel()
        setupDescriptionLabel()
        setupQiwiLinkLabel()
    }
    
    
    
    private func setupPhoto() {
        view.addSubview(photo)
        photo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        photo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        photo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        photo.heightAnchor.constraint(equalTo: photo.widthAnchor).isActive = true
    }
    
    private func setupNameLabel() {
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    private func setupDescriptionLabel() {
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    private func setupQiwiLinkLabel() {
        view.addSubview(qiwiLinkLabel)
        qiwiLinkLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        qiwiLinkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        qiwiLinkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func configure(charity: CharityClass) {
        self.nameLabel.text = charity.name
        self.descriptionLabel.text = charity.descript
        loadPhoto(urlString: charity.photoURL ?? "")
    }
    
    func loadPhoto(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.photo.image = UIImage(named: "imageCharity")
            return
        }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.photo.image = image
                    }
                }
            }
        }
    }

}
