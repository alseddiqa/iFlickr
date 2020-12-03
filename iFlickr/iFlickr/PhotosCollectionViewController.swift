//
//  PhotosCollectionViewController.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/29/20.
//

import UIKit
import CoreLocation

class PhotosCollectionViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var photosCollectionView: UICollectionView!
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    var locationManager: PhotoLocationService!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = PhotoLocationService()
        locationManager.delegate = self
        
        self.photosCollectionView.delegate = self
        self.photosCollectionView.dataSource = self.photoDataSource
        
    }
    
    func fetchPhotosInUserLocation(lat: Double, lon: Double) {
        
        self.store.fetchPhotosForLocation(lat:lat , lon: lon) {
            (photosResult) in
            switch photosResult {
            case let .success(photos):
                print("Found \(photos.count) photos.")
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            
            self.photosCollectionView.reloadSections(IndexSet(integer: 0))
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        // Download the image data, which could take some time
        store.fetchImage(for: photo) { (result) -> Void in
            // The index path for the photo might have changed between the
            // time the request started and finished, so find the most
            // recent index path
            guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo),
                  case let .success(image) = result else {
                return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            // When the request finishes, find the current cell for this photo
            if let cell = self.photosCollectionView.cellForItem(at: photoIndexPath)
                as? PhotoCell {
                cell.update(displaying: image)
                
                let photoLocation = CLLocation(latitude: Double(photo.latitude)!, longitude:  Double(photo.longitude)!)
                let distance = self.getDistanceFromPhotoLocation(currentLocation: self.locationManager.lastLocation!, photoLocation: photoLocation)
                cell.distance.text = "\(distance)km"
                
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        let itemWidth = view.safeAreaLayoutGuide.layoutFrame.size.width / 3
        let itemLength = view.safeAreaLayoutGuide.layoutFrame.size.height / 3
        print("------")
        print(itemWidth)
        
        let finalItemLength = floor(min(itemWidth, itemLength))
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: finalItemLength - 10 , height: finalItemLength - 10)
        
        
        if itemWidth > itemLength {
            layout.scrollDirection = .horizontal
            
        }else {
            layout.scrollDirection = .vertical
        }
        
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
        //        layout.scrollDirection = .horizontal
        
        photosCollectionView.collectionViewLayout = layout
    }
    
    func getDistanceFromPhotoLocation(currentLocation: CLLocation, photoLocation: CLLocation) -> Int{
        
        let distanceInMeters = currentLocation.distance(from: photoLocation)/1000
                
        return Int(distanceInMeters)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showSelectedPhoto":
            if let selectedIndexPath =
                photosCollectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destination as! PhotoDetailViewController
                destinationVC.photo = photo
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
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

extension PhotosCollectionViewController: LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        self.store = PhotoStore()
        self.fetchPhotosInUserLocation(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
