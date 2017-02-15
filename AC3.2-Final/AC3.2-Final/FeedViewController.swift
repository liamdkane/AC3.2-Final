//
//  FeedViewController.swift
//  AC3.2-Final
//
//  Created by C4Q on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseAuth

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBar()
    }

    //MARK: - View Hierarchy and Constraints
    
    func setupNavigationBar () {
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutButtonPressed))
        self.view.addSubview(UINavigationBar())
        self.navigationItem.title = "FEED"
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    func setUpTableView() {
        self.view.addSubview(feedTableView)
        feedTableView.dataSource = self
        feedTableView.delegate = self
        
        feedTableView.snp.makeConstraints { (view) in
            view.top.bottom.trailing.leading.equalToSuperview()
        }
    }
        
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
    
    var feedTableView: UITableView = {
        let view = UITableView()
        view.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.cellID)
        view.estimatedRowHeight = 400
        view.rowHeight = UITableViewAutomaticDimension
        return view
    }()
    
    //MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.cellID, for: indexPath) as! PhotoTableViewCell
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
