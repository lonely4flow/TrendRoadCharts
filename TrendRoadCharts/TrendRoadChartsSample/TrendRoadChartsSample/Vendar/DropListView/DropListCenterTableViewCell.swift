//
//  DropListCenterTableViewCell.swift
//  DropListView
//
//  Created by CIA on 30/11/2017.
//  Copyright © 2017 CIA. All rights reserved.
//

import UIKit

@objc enum DropCellAlignment:Int {
    case left = 0
    case minddle = 1
}

class DropListCenterTableViewCell: UITableViewCell {
    
    init(identifer:String,aliment:DropCellAlignment) {
        cellAliment = aliment
        super.init(style: .default, reuseIdentifier: identifer)
        processContentView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contentImageView = UIImageView()
    var contentLabel = UILabel()
    var cellAliment = DropCellAlignment.left
    
    func processContentView()  {
        self.contentView.addSubview(contentImageView)
        self.contentView.addSubview(contentLabel)
    }
    
    var dropCellConfig:DropCellConfigure?{
        didSet{
            self.contentImageView.image = dropCellConfig?.iconImage
            self.contentLabel.font = dropCellConfig?.titleFont
            self.contentLabel.textColor = dropCellConfig?.titleColor
            self.contentLabel.text = dropCellConfig?.title
            self.contentView.backgroundColor = dropCellConfig?.cellBackGroundColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if cellAliment == .left{
            self.contentImageView.sizeToFit()
            self.contentLabel.sizeToFit()
            
            self.contentImageView.center = CGPoint(x: self.contentImageView.frame.size.width/2 + 8, y: self.contentView.frame.size.height/2)
            
            let imageViewLeft = contentImageView.frame.origin.x + contentImageView.frame.size.width
            self.contentLabel.center = CGPoint(x: self.contentLabel.frame.size.width/2 + 8 + imageViewLeft, y: self.contentView.frame.size.height/2)
        } else {
            self.contentImageView.sizeToFit()
            self.contentLabel.sizeToFit()
            
            let totalWidth = contentImageView.frame.size.width + contentLabel.frame.size.width + 8
            guard totalWidth > 0 else {
                return
            }
            
            let leftBegin = (contentView.frame.size.width - totalWidth)/2
            let centerY = contentView.frame.size.height/2
            let imageCenterX = leftBegin + contentImageView.frame.size.width/2
            let labelCenterX = leftBegin + contentImageView.frame.size.width + 8 + contentLabel.frame.size.width/2
            self.contentImageView.center = CGPoint(x: imageCenterX, y: centerY)
            self.contentLabel.center = CGPoint(x: labelCenterX, y: centerY)
        }
    }

}
