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
    //let customDispatch = DispatchQueue(label: "com.iFlickr", qos: .background)
    let queue = OperationQueue()

    var locationManager: PhotoLocationService!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queue.maxConcurrentOperationCount = 1
        queue.qualityOfService = .userInteractive
        
        let operation1 = BlockOperation {
            self.locationManager = PhotoLocationService()
        }
        
        let operation2 = BlockOperation {
            self.store = PhotoStore()
            self.fetchPhotosInUserLocation()
        }
        
        operation2.addDependency(operation1)
        queue.addOperation(operation1)
        queue.addOperation(operation2)
        
        queue.waitUntilAllOperationsAreFinished()
        self.photosCollectionView.delegate = self
        self.photosCollectionView.dataSource = self.photoDataSource
        
    }
    
    func fetchPhotosInUserLocation() {
        
        
        let currentLat = locationManager.getLatitude()
        let currentLon = locationManager.getLongitude()
        print("----")
        print(currentLat)
        print(currentLon)
        self.store.fetchPhotosForLocation(lat:currentLat , lon: currentLon) {
            (photosResult) in
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) photos.")
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            
            self.photosCollectionView.reloadSections(IndexSet(integer: 0))
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let flickrAPI = FlickrAPI(lat: 24.7136, lon: 46.6753)
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
                
                
                print(photo.latitude)
                
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        let itemWidth = view.safeAreaLayoutGuide.layoutFrame.size.width / 4
        let itemLength = view.safeAreaLayoutGuide.layoutFrame.size.height / 4
        
        let finalItemLength = floor(min(itemWidth, itemLength))
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: finalItemLength , height: finalItemLength )
        
        
        if itemWidth > itemLength {
            layout.scrollDirection = .horizontal
            
        }else {
            layout.scrollDirection = .vertical
        }
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        //        layout.scrollDirection = .horizontal
        
        photosCollectionView.collectionViewLayout = layout
    }
    
    func getDistanceFromPhotoLocation(currentLocation: CLLocation, photoLocation: CLLocation) -> Double{
        
        let distanceInMeters = currentLocation.distance(from: photoLocation)
        
        return distanceInMeters
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

//extension PhotosCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let identifier = "PhotoCollectionViewCell"
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCell
//
////        let photo = store.photos[indexPath.item]
////        cell.imageView.load(url: photo.remoteURL!)
//        cell.update(displaying: nil)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(store.photos.count)
//        return store.photos.count
//
//    }
//}

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
