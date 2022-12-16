//
//  ViewController.swift
//  Charity
//
//  Created by Al Stark on 16.10.2022.
//

import UIKit
import SnapKit
import GoogleSignIn


final class OpenViewController: UIViewController {
    
//    private let googleButton: GIDSignInButton = GIDSignInButton()
    let signInConfig = GIDConfiguration(clientID: "749688238426-o6ol52m3pt0b0ngf6b4jm5qkt4efhqri.apps.googleusercontent.com")
    
    private let userdefault = UserDefaults()
    
    private lazy var emailSignButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign in with email", for: .normal)
        button.layer.cornerRadius = 20.0
        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.layer.borderWidth = 1.0
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var googleSignButton: GIDSignInButton = {
        let button = GIDSignInButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20.0
        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var faceBookSignButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 20
        button.layer.borderColor = .init(red: 0, green: 0, blue: 0, alpha: 0.5)
        button.layer.borderWidth = 1
        button.setTitle("Sign in with Facebook", for: .normal)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubviews(
            [
                emailSignButton,
                googleSignButton,
                faceBookSignButton,
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(buttonsStackView)
        makeConstraints()
    }
    
    private func makeConstraints() {
        buttonsStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(220)
        }
    }
    
    @objc private func googleButtonTapped() {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [weak self] user, error in
            guard error == nil else { return }
            let tabBarVC = TabViewController()
            self?.navigationController?.setViewControllers([tabBarVC], animated: true)
//            self?.navigationController?.pushViewController(MainTableViewController(), animated: true)
            self?.userdefault.set(user?.userID, forKey: "uid")
          }
    }
    
    @objc private func emailButtonTapped() {
        let emailVC = EmailSignViewController()
        self.navigationController?.pushViewController(emailVC, animated: true)
    }
}




