//
//  FavoritePhotoTableViewCell.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/3/20.
//

import UIKit

class FavoritePhotoTableViewCell: UITableViewCell {

    // Table cell custom class for the favorite photo
    
    @IBOutlet var photoTitle: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoViews: UILabel!
    @IBOutlet var photoDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
