//
//  AddCharityViewController.swift
//  Charity
//
//  Created by Al Stark on 16.12.2022.
//

import UIKit

protocol setCoorfinateProtocol {
    func setCoordinateLabel(longitude: Double, latitude: Double)
}

class AddCharityViewController: UIViewController {
    
    private let shared = Service.shared
    
    private var longitude: Double = 0.0
    private var latitude: Double = 0.0
    
    private var longitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "долгота:"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private var latitudeLabel: UILabel = {
        let label = UILabel()
        label.text = "широта:"
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = generateTextField(title: "Введите название благотворительности")
        return textField
    }()

    private lazy var descriptionTextField: UITextField = {
        let textFIeld = generateTextField(title: "Введите описание благотворительности")
        return textFIeld
    }()
    
    private lazy var qiwiTextField: UITextField = {
        let textFIeld = generateTextField(title: "Введите ссылку на Qiwi - кошелек")
        return textFIeld
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubviews([
            nameTextField,
            descriptionTextField,
            qiwiTextField,
        ])
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var addLocationButton:UIButton = {
        let button = UIButton()
        button.setTitle("добавить геопозицию", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 4
        return button
    }()
    
    private var nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить благотворительность", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupStackView()
        setupLabels()
        setupAddLocationButton()
        setupNextButton()
    }
    
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupLabels() {
        view.addSubview(longitudeLabel)
        view.addSubview(latitudeLabel)
        longitudeLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
        longitudeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        latitudeLabel.topAnchor.constraint(equalTo: longitudeLabel.bottomAnchor, constant: 10).isActive = true
        latitudeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupAddLocationButton() {
        view.addSubview(addLocationButton)
        addLocationButton.topAnchor.constraint(equalTo: latitudeLabel.bottomAnchor, constant: 20).isActive = true
        addLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addLocationButton.widthAnchor.constraint(equalToConstant: 240).isActive = true
        addLocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addLocationButton.addTarget(self, action: #selector(addLocationButtonTapped), for: .touchUpInside)
    }

    
    private func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: addLocationButton.bottomAnchor, constant: 30).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 280).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addLocationButtonTapped() {
        let vc = AnnotationCoordMapViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
//        var nav = self.navigationController?.viewControllers
//        nav?.append(vc)
//        self.navigationController?.viewControllers = nav ?? []
    }
    
    @objc private func nextButtonTapped() {
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let qiwi = qiwiTextField.text ?? ""
        if name.isEmpty || description.isEmpty || qiwi.isEmpty {
            showAlert(title: "Ошибка", message: "Заполните все поля")
        } else {
            var latitude: Double? = nil
            var longitude: Double? = nil
            if latitude != 0.0 {
                latitude = self.latitude
                longitude = self.longitude
            }
            print(latitude)
            let uid = UserDefaults().string(forKey: "uid") ?? ""
            let charity = Charity(creatorID: uid,
                                  name: nameTextField.text ?? "",
                                  description: descriptionTextField.text ?? "",
                                  photoURL: nil,
                                  latitude: latitude,
                                  longitude: longitude,
                                  art: false,
                                  children: false,
                                  education: false,
                                  healthcare: false,
                                  poverty: false,
                                  scienceResearch: false,
                                  qiwiURL: qiwiTextField.text)
            shared.pushCharity(charity: charity)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(title: String , message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default))
        
        present(alert, animated: true)
    }

    private func generateTextField(title: String) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .white

        let placeholderText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.attributedPlaceholder = placeholderText
        textField.borderStyle = .bezel
        textField.backgroundColor = .white
        textField.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        textField.layer.borderWidth = 1.0
        textField.textColor = .black
        textField.layer.cornerRadius = 10.0
        textField.borderStyle = .roundedRect
//        textField.isSecureTextEntry = true
        return textField
    }
}

extension AddCharityViewController: setCoorfinateProtocol {
    func setCoordinateLabel(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
        latitudeLabel.text = "ширина: \(latitude)"
        longitudeLabel.text = "долгота: \(longitude)"
    }
}
