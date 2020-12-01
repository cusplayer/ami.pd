//
//  ArticleCollectionViewCell.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        background.cornerRadius = 20
    }
    
    public func setColor(_ color: UIColor?) {
        background.backgroundColor = color
    }
    
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }

}
