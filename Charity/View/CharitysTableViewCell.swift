//
//  CharitysTableViewCell.swift
//  Charity
//
//  Created by Al Stark on 30.11.2022.
//

import UIKit


class CharitysTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CharitysTableViewCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.text = "title"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "decription"
        return label
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubviews(
            [titleLabel,
             descriptionLabel,
            ]
        )
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.selectionStyle = .none
            setupView()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        setupImage()
        setupStackView()
    }
    
    private func setupImage() {
        contentView.addSubview(image)
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 24).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24).isActive = true
    
    }
    
    func configure(charity: CharityClass) {
        self.titleLabel.text = charity.name
        self.descriptionLabel.text = charity.descript
        loadPhoto(urlString: charity.photoURL ?? "")
    }
    
    func loadPhoto(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.image.image = UIImage(named: "imageCharity")
            return
        }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image.image = image
                    }
                }
            }
        }
    }
}
