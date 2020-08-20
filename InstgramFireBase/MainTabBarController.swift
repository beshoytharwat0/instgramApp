//
//  MainTabBarController.swift
//  InstgramFireBase
//
//  Created by Mac on 7/22/20.
//  Copyright © 2020 beshoy tharwat. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if Auth.auth().currentUser == nil {
            // show if not login
            DispatchQueue.main.async {
                let login = LogInController()
                let navController = UINavigationController(rootViewController: login)
                self.present(navController, animated: true, completion: nil)
            }
           
            return
        }
        
       setupViewController()
    }
    func setupViewController(){
        
        // home
        let homeNavController = templaterNavController(image: #imageLiteral(resourceName: "home-7"), selectedImage: #imageLiteral(resourceName: "house-7") ,rootViewController: UIViewController())
        
        // search
        
        let searchNavController = templaterNavController(image: #imageLiteral(resourceName: "search-7"), selectedImage: #imageLiteral(resourceName: "search-7"), rootViewController: UIViewController())
        
        // add
        
        let addNavController = templaterNavController(image: #imageLiteral(resourceName: "plus-simple-7"), selectedImage: #imageLiteral(resourceName: "plus-simple-7"), rootViewController: UIViewController())
        
        // heart
        
        let heartNavController = templaterNavController(image: #imageLiteral(resourceName: "heart-7"), selectedImage: #imageLiteral(resourceName: "heart-7"), rootViewController: UIViewController())
//    //    let heartViewController = UIViewController()
//        let heartNavController = UINavigationController(rootViewController: heartViewController)
//        heartNavController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "heart-7"), selectedImage: #imageLiteral(resourceName: "heart-7"))
        
        // userProfile
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "circle-user-7"), selectedImage: #imageLiteral(resourceName: "circle-user-7"))
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController, searchNavController, addNavController, heartNavController, userProfileNavController]
        
        // modifty tab bar item insets to make icon in midle of tab bar
        
        guard let  items = tabBar.items else {return}
        for item in items {
           item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -3, right: 0)
            
        }
    }
    
    
    fileprivate func templaterNavController (image: UIImage, selectedImage: UIImage, rootViewController : UIViewController = UIViewController()) -> UINavigationController {
       let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem = UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
        return navController
    }
}
