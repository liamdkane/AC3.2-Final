//
//  FeedViewController.swift
//  AC3.2-Final
//
//  Created by C4Q on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseAuth

class FeedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpNavigationBar()
    }

    //MARK: - View Hierarchy and Constraints
    
    func setUpNavigationBar () {
        self.view.addSubview(UINavigationBar())
        self.navigationItem.title = "FEED"
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    var logoutButton: UIBarButtonItem = {
        let view = UIBarButtonItem(title: "LOGOUT", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutButtonPressed))
        return view
    }()
    
    //MARK: - Actions
    func logoutButtonPressed () {
        print("pressed")
        if let _ = FIRAuth.auth()?.currentUser {
            do {
                try FIRAuth.auth()?.signOut()
                print("logged out")
            } catch {
                print("Error occured while logging out: \(error)")
            }
        }
        self.present(LoginViewController(), animated: true, completion: nil)
    }
    
    //MARK: - Views
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
