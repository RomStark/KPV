//
//  MainTableViewController.swift
//  Charity
//
//  Created by Al Stark on 28.11.2022.
//

import UIKit
import FirebaseAuth
import CoreLocation

final class MainTableViewController: UIViewController {
    
    static var charities = [CharityClass]()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise"), style: .plain, target: self, action: #selector(refreshData))

        setupTableView()
        getCharities()
    }
    
    @objc private func refreshData() {
        getCharities()
    }
    
    private func getCharities() {
        Service.shared.getListOfCharitys { [weak self] charities in
            MainTableViewController.charities = charities.compactMap {
                CharityClass(coordinate: CLLocationCoordinate2D(latitude: $0.latitude ?? 0.0, longitude: $0.longitude ?? 0),
                             name: $0.name,
                             description: $0.description,
                             photoURL: $0.photoURL,
                             qiwiURL: $0.qiwiURL)
                            }
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        tableView.register(CharitysTableViewCell.self, forCellReuseIdentifier: CharitysTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MainTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let charityVC = CharityViewController()
        charityVC.configure(charity: MainTableViewController.charities[indexPath.row])
        navigationController?.pushViewController(charityVC, animated: true)
    }
    
}

extension MainTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MainTableViewController.charities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharitysTableViewCell.reuseIdentifier, for: indexPath) as? CharitysTableViewCell
        cell?.configure(charity: MainTableViewController.charities[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    
}
