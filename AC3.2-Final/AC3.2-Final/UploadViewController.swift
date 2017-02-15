//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by C4Q on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

import AVKit
import AVFoundation
import MobileCoreServices


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        setupNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - View Hierarchy and Constraints
    
    func setupNavigationBar () {
        let uploadButton = UIBarButtonItem(title: "UPLOAD", style: UIBarButtonItemStyle.plain, target: self, action: #selector(uploadButtonPressed))
        self.view.addSubview(UINavigationBar())
        self.navigationItem.title = "POST IMAGES HERE"
        self.navigationItem.rightBarButtonItem = uploadButton
    }

    
    func setupViewHierarchy () {
        let views = [uploadImageView, commentTextView].map { self.view.addSubview($0) }
    }
    
    func configureConstraints () {
        self.edgesForExtendedLayout = []
        
        uploadImageView.snp.makeConstraints { (view) in
            view.top.width.centerX.equalToSuperview()
            view.height.equalTo(uploadImageView.snp.width)
        }
        
        commentTextView.snp.makeConstraints { (view) in
            view.top.equalTo(uploadImageView.snp.bottom)
            view.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Views
    
    var uploadImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        
        view.image = UIImage(named: "camera_icon")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        
        
        //TO DO fix this shit -- WHY ISNT IT WORKING?!
        view.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadImageTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        return view
    }()

    var commentTextView: UITextView = {
        let view = UITextView()
        view.text = "Add Comment...."
        return view
    }()
    
    
    //MARK - Actions
    
    
    func uploadImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        imagePickerController.mediaTypes = [String(kUTTypeImage)]
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func uploadButtonPressed() {
        let databaseRef = FIRDatabase.database().reference().child("posts").childByAutoId()
        let storageRef = FIRStorage.storage().reference().child("images/\(databaseRef.key)")
        
        let jpeg = UIImageJPEGRepresentation(self.uploadImageView.image!, 0.7)
        
        let newMetadata = FIRStorageMetadata()
        newMetadata.cacheControl = "public,max-age=300"
        newMetadata.contentType = "image/jpeg"

        
        storageRef.put(jpeg!, metadata: newMetadata) { (metadata, error) in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
            if let _ = metadata {
                self.showAlert(title: "Success", message: "hopefully this gets liked..")
            }
        }
        
        let photo = FIRPhotoObject(key: databaseRef.key,
                                   userID: (FIRAuth.auth()?.currentUser?.uid)!,
                                   comment: self.commentTextView.text)
        
        databaseRef.setValue(photo.asDictionary)
        }
    
    
    //MARK: - Alert
    
    
    func showAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - Image Pick Delegate
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if info[UIImagePickerControllerMediaType] as! String == kUTTypeImage as String {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.uploadImageView.image = image
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func doesNotRecognizeSelector(_ aSelector: Selector!) {
        print("fucked.")
    }
}
