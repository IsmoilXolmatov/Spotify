//
//  WelcomeVC.swift
//  Spotify
//
//  Created by Khalmatov on 10.09.2023.
//

import UIKit

class WelcomeVC: UIViewController {
    
    private let signInBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign in with spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
    }
    
    private func setUpUI() {
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInBtn)
        signInBtn.addTarget(self, action: #selector(didTapSign), for: .touchUpInside)
        signInBtn.frame = CGRect(
            x: 20,
            y: view.height-100-view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 50
        )
     }
   
    @objc func didTapSign() {
        let vc = AuthVC()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completionHandler = { [weak self] success in
            self?.handleSignIn(success: success)
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Ooops", message: "Something went wrong while signing in", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
                self?.didTapSign()
            }
            alert.addAction(okAction)
            present(alert, animated: true)
            return
        }
        let tabBarVC = TabBarVC()
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
     }
 
}
