//
//  AnnotationCoordMapViewController.swift
//  Charity
//
//  Created by Al Stark on 16.12.2022.
//

import UIKit
import MapKit

class AnnotationCoordMapViewController: UIViewController {
    
    private var geocoder = CLGeocoder()
    private var longitude: Double = 0.0
    private var latitude: Double = 0.0
    
    var delegate: setCoorfinateProtocol?

    private let map: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    private let adressTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white

        let placeholderText = NSAttributedString(string: "Введите адрес", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        textField.attributedPlaceholder = placeholderText
        textField.borderStyle = .bezel
        textField.backgroundColor = .white
        textField.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        textField.layer.borderWidth = 1.0
        textField.textColor = .black
        textField.layer.cornerRadius = 10.0
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let confirmAdressButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать место", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.backgroundColor = .red
        button.layer.cornerRadius = 8
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
    }
    private func setupUI() {
        setupMap()
        setupAdressTextField()
        setupConfirmAdressButton()

    }
    
    @objc private func textFieldDidChanged() {
        geocoder.geocodeAddressString(adressTextField.text ?? "") { [weak self] placemarks, error in
            
            guard let self else { return }
            
            if error != nil {
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            
            self.map.removeAnnotations(self.map.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.title = "You here"
            annotation.subtitle = self.adressTextField.text ?? ""
            annotation.coordinate = placemark.location?.coordinate ?? CLLocationCoordinate2D()
            self.longitude = placemark.location?.coordinate.longitude ?? 0.0
            self.latitude = placemark.location?.coordinate.latitude ?? 0.0
            
            self.map.showAnnotations([annotation], animated: true)
            self.map.selectAnnotation(annotation, animated: true)
        }
    }
    
    @objc private func confirmAdressButtonTapped() {
        delegate?.setCoordinateLabel(longitude: longitude, latitude: latitude)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupMap() {
        view.addSubview(map)
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        map.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        map.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
    }
    
    private func setupAdressTextField() {
        view.addSubview(adressTextField)
        adressTextField.topAnchor.constraint(equalTo: map.bottomAnchor).isActive = true
        adressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        adressTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        adressTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)

    }
    
    
    
    private func setupConfirmAdressButton() {
        view.addSubview(confirmAdressButton)
        confirmAdressButton.topAnchor.constraint(equalTo: map.bottomAnchor).isActive = true
        confirmAdressButton.leadingAnchor.constraint(equalTo: adressTextField.trailingAnchor).isActive = true
        confirmAdressButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        confirmAdressButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        confirmAdressButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        confirmAdressButton.addTarget(self, action: #selector(confirmAdressButtonTapped), for: .touchUpInside)

    }

    
}
