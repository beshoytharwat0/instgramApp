//
//  UserProfileController.swift
//  InstgramFireBase
//
//  Created by Mac on 7/22/20.
//  Copyright © 2020 beshoy tharwat. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
       // navigationItem.title = Auth.auth().currentUser?.uid
       fetchUser()
    
       collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerId")
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        setupLogOutButton()
    }
    
    fileprivate func setupLogOutButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handelLogOut))
    }
    
    @objc func handelLogOut(){
        let alertController = UIAlertController(title: nil , message: nil , preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                // what happens?after logout from firedase
                let loginController = LogInController()
                let navcontroller = UINavigationController(rootViewController: loginController)
                self.present(navcontroller, animated: true, completion: nil)
            }catch{
                print("Failed to sign out:", error)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath) as! UserProfileHeader
        header.user = self.user
        
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    var user: User?
   fileprivate func fetchUser() {
    guard let uid = Auth.auth().currentUser?.uid else {return}
 Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        print(snapshot.value ?? "")
        guard let dictionary = snapshot.value as? [String: Any] else {return}
    
         self.user = User.init(dictionary: dictionary)
    
    self.navigationItem.title = self.user?.username
    
    self.collectionView?.reloadData()
    }) { (err) in
        print("Failed to fetch user:", err)
    }
    
    }
}

struct User {
    let username: String
    let profileImageUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}