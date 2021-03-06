//
//  PhotoTableViewCell.swift
//  AC3.2-Final
//
//  Created by C4Q on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    static let cellID = "photo cell id"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViewHierarchy()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.uploadedImageView.image = nil
        self.commentLabel.text = "Comments..."
    }
    
    //MARK: - View Hierarchy and Constraints
    
    func setupViewHierarchy() {
        self.contentView.addSubview(uploadedImageView)
        self.contentView.addSubview(commentLabel)
    }
    
    func configureConstraints () {
        uploadedImageView.snp.makeConstraints { (view) in
            view.leading.trailing.top.equalToSuperview()
            view.height.equalTo(uploadedImageView.snp.width)
        }
        
        commentLabel.snp.makeConstraints { (view) in
            view.trailing.bottom.equalToSuperview().inset(6)
            view.leading.equalToSuperview().offset(6)
            view.top.equalTo(uploadedImageView.snp.bottom).offset(6)
        }
    }
    
    //MARK: - Views
    
    var uploadedImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    var commentLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
}
