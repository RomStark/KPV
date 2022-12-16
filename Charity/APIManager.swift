//
//  APIManager.swift
//  Charity
//
//  Created by Al Stark on 17.10.2022.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

final class APIManager {
    static let shared = APIManager()
    
    private func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
}
