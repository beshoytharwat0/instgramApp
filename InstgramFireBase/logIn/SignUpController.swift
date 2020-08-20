//
//  SignUpController.swift
//  InstgramFireBase
//
//  Created by Mac on 7/20/20.
//  Copyright © 2020 beshoy tharwat. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "AddImage").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto() {
       let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage{
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }else if let originalImage = info[.originalImage] as? UIImage{
            plusPhotoButton.setBackgroundImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor   = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth   = 2
        dismiss(animated: true, completion: nil)
    }
    
    let emailTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = " Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handelTextChange), for: .editingChanged)
        return tf
        
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handelTextChange), for: .editingChanged)
        return tf
        
    }()
    
    @objc func handelTextChange() {
        let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        }else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        }
    }
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Password"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(handelTextChange), for: .editingChanged)
        return tf
        
    }()
    
    let signUpButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let alreadyHaveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor: UIColor.gray])
        attributedTitle.append(NSAttributedString(string: "  Sign In", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18),NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
       @objc func handleShowSignUp(){
            let signIn = LogInController()
            navigationController?.pushViewController(signIn, animated: true)
        }
    
   @objc func handleSignUp(){
    guard let email = emailTextField.text, email.characters.count > 0  else{return}
    guard let userName = usernameTextField.text, userName.characters.count > 0 else {return}
    guard let password = passwordTextField.text, password.characters.count > 0 else {return}
    
   
    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
        if  let err = error {
            print("Can't Creat user:", err)
            return
        }
        guard let image = self.plusPhotoButton.imageView?.image else {return}
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_image").child(fileName)
        
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
            if let err = err  {
                
                print("Failed to save profile Image in to storage:", err)
                return
            }
             storageRef.downloadURL(completion: { (url, err) in
                if let err = err {
                    
                    print(err)
                    return
                }
                guard let profileImageUrl = url?.absoluteString else {return}
                print(profileImageUrl)
                
                print("Successfully saved user info to storage")
                print("Successfully created user:",user?.user.uid ?? "")
                guard let uid = user?.user.uid else {return}
                let dictionaryValues = ["username": userName, "profileImageUrl": profileImageUrl]
                let values = [uid: dictionaryValues]
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if let err = err {
                        print("Failed to save user info ito db:", err)
                    }
                    print("Successfully saved user info to db")
                    guard let mainTabBarController =  UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
                    mainTabBarController.setupViewController()
                    self.dismiss(animated: true, completion: nil)
                })

            })
            print("Successfully saved user info to storage")
           
            
        })
      }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
       view.addSubview(plusPhotoButton)
     NSLayoutConstraint.activate([
//        plusPhotoButton.heightAnchor.constraint(equalToConstant: 140),
//        plusPhotoButton.widthAnchor.constraint(equalToConstant: 140),
          plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//        plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        ])
        
        plusPhotoButton.anchor(top: view.topAnchor, bottom: nil, leading: nil, trailing: nil, paddingTop: 60, paddingBottom: 0, paddingLead: 0, paddingTrail: 0, width: 140, height: 140)
        
        view.addSubview(alreadyHaveAccountButton)
        
        alreadyHaveAccountButton.anchor(top: nil, bottom: view.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingBottom: -20, paddingLead: 0, paddingTrail: 0, width: 0, height: 50)
        
        setupInputFields()
        
//        view.addSubview(emailTextField)

    }
    
    private func setupInputFields(){
       
        let stackView = UIStackView(arrangedSubviews: [emailTextField,usernameTextField,passwordTextField,signUpButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        
//          NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 40),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
//            stackView.heightAnchor.constraint(equalToConstant: 200)
//                    ])
        stackView.anchor(top: plusPhotoButton.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingLead: 40, paddingTrail: -40, width: 0, height: 200)
    }
    
    
}

extension UIView{
    
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?,trailing: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingBottom: CGFloat, paddingLead: CGFloat, paddingTrail: CGFloat, width: CGFloat, height: CGFloat){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let leading = leading {
            
            self.leadingAnchor.constraint(equalTo: leading, constant: paddingLead).isActive = true
        }
        if let trailing = trailing {
            
            self.trailingAnchor.constraint(equalTo: trailing, constant: paddingTrail).isActive = true
        }
        if  width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}
