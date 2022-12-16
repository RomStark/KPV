//
//  Service.swift
//  Charity
//
//  Created by Al Stark on 16.11.2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Service {
    
    let userdefault = UserDefaults.standard
    static let shared = Service()
    
    private func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func getUser(completion: @escaping (_ user: User) -> Void) {
        let uid = userdefault.string(forKey: "uid")
        if uid != "" {
            Firestore.firestore().collection("users").document(uid ?? "").getDocument { document, error in
                if let _ = error {
                    return
                }
                guard let document = document else {
                    return
                }
                let data = document.data()
                let user = User(name: data?["name"] as? String ?? "", email: data?["email"] as? String ?? "", photoURL: data?["photourl"] as? String)
                completion(user)
            }
        }
    }
    
    
    func createNewUser(
        name: String,
        email: String,
        password: String,
        completion: @escaping (Result<String, SignAnswer>) -> Void
    ) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                switch (error as NSError).code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    completion(.failure(.emailExist))
                default:
                    completion(.failure(.unknownError))
                }
            }
            
            guard let result = result else {
                completion(.failure(.unknownError))
                return
            }
            
            let data = ["email": email, "name": name]
            Firestore.firestore().collection("users").document(result.user.uid).setData(data)
            completion(.success(result.user.uid))
        }
    }
    
    func authWithEmail(email: String,
                       password: String,
                       completion: @escaping (SignAnswer) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                switch (error as NSError).code {
                case AuthErrorCode.invalidEmail.rawValue:
                    completion(.emailNotExist)
                case AuthErrorCode.unverifiedEmail.rawValue:
                    completion(.emailNotVerified)
                case AuthErrorCode.wrongPassword.rawValue:
                    completion(.wrongPassword)
                default:
                    completion(.unknownError)
                }
            }
            self?.userdefault.set(result?.user.uid, forKey: "uid")
        }
    }
    
    func confirmEmail() {
        Auth.auth().currentUser?.sendEmailVerification( completion: { error in
            print(Auth.auth().currentUser?.uid ?? "frverv")
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    func changePassword(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func pushCharity(charity: Charity) {
        let userID = UserDefaults().string(forKey: "uid")
//        let data: Data = try JSONEncoder().encode(charity)
//        guard let data = data else { return }
        var data = [String : Any]()
        if charity.longitude == nil {
            data = ["name": charity.name, "description": charity.description, "qiwiurl": charity.qiwiURL, "creatorid": userID] as [String : Any]
        } else {
            data = ["name": charity.name, "description": charity.description, "qiwiurl": charity.qiwiURL, "creatorid": userID, "latitude": charity.latitude, "longitude": charity.longitude] as [String : Any]
        }
        
        Firestore.firestore().collection("charities").document(charity.name).setData(data as [String : Any])
    }
    
    func getListOfCharitys(completion: @escaping ([Charity]) -> ()) {
        Firestore.firestore().collection("charities").getDocuments { query, error in
            if let error = error {
                print(error.localizedDescription)
            }
            var charitiesList = [Charity]()
            guard let docs = query?.documents else {
                completion([])
                return
            }
            
            
            for doc in docs {
                let data = doc.data()
//                charitiesList.append(JSONDecoder().decode(Charity.self, from: data))
                let charity = Charity(
                    creatorID: data["creatorid"] as? String ?? "creatorID",
                    name: data["name"] as? String ?? "name",
                    description: data["description"] as? String ?? "description",
                    photoURL: data["photourl"] as? String,
                    latitude: data["latitude"] as? Double,
                    longitude: data["longitude"] as? Double,
                    art: data["art"] as? Bool ?? false,
                    children: data["children"] as? Bool ?? false,
                    education: data["education"] as? Bool ?? false,
                    healthcare: data["healthcare"]as? Bool ?? false,
                    poverty: data["poverty"] as? Bool ?? false,
                    scienceResearch: data["science&research"] as? Bool ?? false,
                    qiwiURL: data["qiwiurl"] as? String
                )
                charitiesList.append(charity)
            }
            completion(charitiesList)
        }
    }
}
