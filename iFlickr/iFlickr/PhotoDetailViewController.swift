//
//  PhotoDetailViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/30/20.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet var imgaeView: UIImageView!
    @IBOutlet var imageTitleLabel: UILabel!
    @IBOutlet var imageDateTakenLabel: UILabel!
    
    var photo: Photo!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        imgaeView.load(url: photo.remoteURL!)
        imageTitleLabel.text = photo.title
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-yyyy HH:mm"
        imageDateTakenLabel.text = dateFormatterGet.string(from: photo.dateTaken)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
