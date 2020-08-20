//
//  ProfileHeader.swift
//  InstgramFireBase
//
//  Created by Mac on 7/23/20.
//  Copyright © 2020 beshoy tharwat. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            setupProfileImage()
        }
    }
    
    let profileImageView : UIImageView = {
       let iv = UIImageView()
        iv.backgroundColor = .red
        return iv
        
    }()
    
    let gridButton : UIButton = {
       let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid-out-many-7"), for: .normal)
        return button
    }()
    
    let listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "text-list-7"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    let bookMarkbutton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "bookmark-7"), for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)

        return button
    }()
    
    let userNameLabel : UILabel = {
      let lbl = UILabel()
        lbl.text = "username"
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let postLabel : UILabel = {
        let lbl = UILabel()
      
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "post", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        lbl.attributedText = attributedText
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    let followersLabel : UILabel = {
        let lbl = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        lbl.attributedText = attributedText
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.numberOfLines = 0

        return lbl
    }()
    let followingLabel : UILabel = {
        let lbl = UILabel()
//        lbl.text = "11\nfollowing"
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]))
        lbl.attributedText = attributedText
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.numberOfLines = 0

        return lbl
    }()
    
    let editProfileButton: UIButton = {
      let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor, bottom: nil, leading: self.leadingAnchor, trailing: nil, paddingTop: 20, paddingBottom: 0, paddingLead: 25, paddingTrail: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80/2
        profileImageView.clipsToBounds = true
        
        usernameLayout()
        setupButtonToolbar()
        setupUserStatsView()
        addSubview(editProfileButton)
       editProfileButton.anchor(top: postLabel.bottomAnchor, bottom: nil, leading: postLabel.leadingAnchor, trailing: followingLabel.trailingAnchor, paddingTop: 15, paddingBottom: 0, paddingLead: 15, paddingTrail: -10, width: 0, height: 35)
        
        
    }
    
    fileprivate func setupUserStatsView() {
       let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: self.topAnchor, bottom: nil, leading: profileImageView.trailingAnchor, trailing: self.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingLead: 12, paddingTrail: 0, width: 0, height: 50)
        
    }
    
    
   fileprivate func usernameLayout(){
        addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor, constant: 10),
            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15),
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: 5),
            ])
        
    }
    
    fileprivate func setupButtonToolbar() {
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookMarkbutton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: nil, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: self.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLead: 0, paddingTrail: 0, width: 0, height: 40)
        
        let topView = UIView()
        topView.backgroundColor = .darkGray
        let bottomView = UIView()
        bottomView.backgroundColor = .darkGray
        addSubview(topView)
        addSubview(bottomView)
        
        topView.anchor(top: stackView.topAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLead: 0, paddingTrail: 0, width: 0, height: 1)
        
        bottomView.anchor(top: stackView.bottomAnchor, bottom: nil, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLead: 0, paddingTrail: 0, width: 0, height: 1)
        
    }

    

    fileprivate func setupProfileImage(){

        guard let profileImageUrl = user?.profileImageUrl else {return}
        guard let userName = user?.username else {return}
        
        
        guard let url = URL(string: profileImageUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            if let err = err {
                print("Failed to fetch profile image:", err)
            }
            guard let data = data else {return}
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.profileImageView.image = image
                self.userNameLabel.text = userName
            }
            
            
            }.resume()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
