//
//  PhotoTableViewCell.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/2/20.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet var photoimageView: UIImageView!
    @IBOutlet var photoTitleLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    /// A helper function to update the image view in the cell, animates spinner when the
    /// - Parameter image: the image to display
    func update(displaying image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            spinner.isHidden = true
            photoimageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            photoimageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    /// To add some spacing between table cells
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
}
