//
//  WaterCollectionViewCell.swift
//  ami
//
//  Created by Artem Kufaev on 30.06.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import UIKit

class WaterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var glassIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tintableImage = glassIcon.image?.withRenderingMode(.alwaysTemplate)
        glassIcon.image = tintableImage
    }
    
    public func setColor(_ color: UIColor?) {
        glassIcon.tintColor = color
    }

}
