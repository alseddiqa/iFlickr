//
//  FlickrAPI.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/29/20.
//

import Foundation
import CoreLocation


enum EndPoint: String {
    case photosSearch = "flickr.photos.search"
}

struct FlickrAPI {
    
    let baseURLString = "https://api.flickr.com/services/rest"
    let apiKey = "a6d819499131071f158fd740860a5a88"

    var latitude = ""
    var longitude = ""
    
    var photosSearchURL: URL {
        return flickrURL(endPoint: .photosSearch,
                         parameters: ["extras": "url_z,date_taken,geo"])
    }
    
    init(lat:Double, lon: Double) {
        self.latitude = String(lat)
        self.longitude = String(lon)
    }
    
    func flickrURL(endPoint: EndPoint,
                                  parameters: [String:String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": endPoint.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey,
            "lat": latitude,
            "lon": longitude,
            "radius": "10",
            "has_geo": "1"
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    static func photos(fromJSON data: Data) -> Result<[Photo], Error> {
        do {
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
            let photos = flickrResponse.photosInfo.photos.filter { $0.remoteURL != nil }
            return .success(photos)
        } catch {
            return .failure(error)
        }
    }
    
//    func getDistanceFromPhoto(photoID: String) -> Double {
//
//
//        let url = URL(string: "https://www.flickr.com/services/rest/" + "?method=\(EndPoint.photoGeoLocation.rawValue)" + "&api_key=\(apiKey)"+"&photo_id=\(photoID)&format=json&nojsoncallback=1")!
//
////        print(url)
//        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
//
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
//
//        let task = session.dataTask(with: request) { (data, response, error) in
//            // This will run when the network request returns
//            if let error = error {
//                print(error.localizedDescription)
//            } else if let data = data {
//
//                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//
//                print(dataDictionary["photo"] as! [String:Any])
//
//
//                let currentCordinates = CLLocation(latitude: 5.0, longitude: 5.0)
//                let coordinate₁ = CLLocation(latitude: 5.0, longitude: 3.0)
//
//                //let distanceInMeters = coordinate₀.distance(from: coordinate₁)
//
//
//            }
//        }
//        task.resume()
//        return 0
//    }
    
}

