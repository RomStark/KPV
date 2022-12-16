//
//  models.swift
//  Charity
//
//  Created by Al Stark on 16.11.2022.
//

import Foundation
import MapKit

struct answer {
    var UID: String
}

final class CharityClass: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    var name: String
    var descript: String
    let photoURL: String?
    let qiwiURL: String?
    var title: String? {
        return name
    }
    init(coordinate: CLLocationCoordinate2D, name: String, description: String, photoURL: String?, qiwiURL: String?) {
        self.coordinate = coordinate
        self.name = name
        self.descript = description
        self.photoURL = photoURL
        self.qiwiURL = qiwiURL
    }
}

struct Charity: Codable {
    let creatorID: String
    let name: String
    let description: String
    let photoURL: String?
    let latitude: Double?
    let longitude: Double?
    let art: Bool
    let children: Bool
    let education: Bool
    let healthcare: Bool
    let poverty: Bool
    let scienceResearch: Bool
    let qiwiURL: String?
}

enum SignAnswer: Error {
    case emailExist
    case emailNotExist
    case unknownError
    case emailNotVerified
    case wrongPassword
}

struct User {
    let name: String
    let email: String
    let photoURL: String?
}
