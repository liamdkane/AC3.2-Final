//
//  FeedViewController.swift
//  AC3.2-Final
//
//  Created by C4Q on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var photos = [FIRPhotoObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBar()
        setUpTableView()
    }

    //MARK: - View Hierarchy and Constraints
    
    func setupNavigationBar () {
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: UIBarButtonItemStyle.plain, target: self, action: #selector(logoutButtonPressed))
        self.view.addSubview(UINavigationBar())
        self.navigationItem.title = "FEED"
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    func setUpTableView() {
        self.edgesForExtendedLayout = []
        
        self.view.addSubview(feedTableView)
        feedTableView.dataSource = self
        feedTableView.delegate = self
        feedTableView.estimatedRowHeight = 400
        feedTableView.rowHeight = UITableViewAutomaticDimension

        feedTableView.snp.makeConstraints { (view) in
            view.top.bottom.trailing.leading.equalToSuperview()
        }
        
        getUploadedImages()
    }
    
    func getUploadedImages () {
        let databaseRef = FIRDatabase.database().reference().child("posts")
        
        databaseRef.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.photos.removeAll()
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot,
                    let valueDict = snap.value as? [String: String] {
                    let photo = FIRPhotoObject(key: snap.key,
                                          userID: valueDict["userID"] ?? "",
                                          comment: valueDict["comment"] ?? "")
                    self.photos.append(photo)
                }
            }
            self.feedTableView.reloadData()
            print(self.photos)
        })

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
        return view
    }()
    
    //MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.cellID, for: indexPath) as! PhotoTableViewCell
        let currentPhoto = self.photos[indexPath.row]
        print(currentPhoto.asDictionary)
        let storageRef = FIRStorage.storage().reference().child("images").child(currentPhoto.key)
        
        storageRef.data(withMaxSize: 1 * 1012 * 1024) { (data, error) in
            if let error = error {
                print(error)
                cell.uploadedImageView.image = UIImage(named: "camera_icon")
            }
            if let validData = data {
                cell.uploadedImageView.image = UIImage(data: validData)
                cell.setNeedsDisplay()
            }
        }
        
        cell.commentLabel.text = currentPhoto.comment
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
