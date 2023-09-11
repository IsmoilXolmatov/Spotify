//
//  TabBarVC.swift
//  Spotify
//
//  Created by Khalmatov on 10.09.2023.
//

import UIKit

class TabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBasicStuffs()

     }
    
    
    fileprivate func setUpBasicStuffs() {
        
        let vc1 = HomeVC()
        let vc2 = SearchVC()
        let vc3 = LibraryVC()
        
        vc1.title = "Browse"
        vc2.title = "Search"
        vc3.title = "Library"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always

        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass.circle.fill"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 3)

        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2, nav3], animated: true)
     }
 

}
