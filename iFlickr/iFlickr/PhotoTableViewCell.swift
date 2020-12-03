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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
