//
//  PhotoCell.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/29/20.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var distance: UILabel!
    
    func update(displaying image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            spinner.isHidden = true
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}


extension UICollectionViewCell {
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    
    }
    
}
