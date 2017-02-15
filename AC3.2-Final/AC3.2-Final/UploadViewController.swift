//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by C4Q on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import FirebaseAuth
import AVKit
import AVFoundation
import MobileCoreServices


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - View Hierarchy and Constraints
    
    func setupViewHierarchy () {
        let views = [uploadImageView].map { self.view.addSubview($0) }
    }
    
    func configureConstraints () {
        self.edgesForExtendedLayout = []
        
        uploadImageView.snp.makeConstraints { (view) in
            view.top.width.centerX.equalToSuperview()
            view.height.equalTo(uploadImageView.snp.width)
        }
    }
    
    //MARK: - Views 
    
    lazy var uploadImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        
        let origImage = UIImage(named: "camera_icon")
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(uploadImageTapped))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 8
        return view
    }()

    func uploadImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        
        imagePickerController.mediaTypes = [String(kUTTypeImage)]
        self.present(imagePickerController, animated: true, completion: nil)
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

}
