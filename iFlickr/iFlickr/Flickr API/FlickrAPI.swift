//
//  FlickrAPI.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/29/20.
//

import Foundation
import CoreLocation

// Declare the end point to search for flick photos.
enum EndPoint: String {
    case photosSearch = "flickr.photos.search"
}

struct FlickrAPI {
    
    //Declaring params to prepare for call
    let baseURLString = "https://api.flickr.com/services/rest"
    let apiKey = "a6d819499131071f158fd740860a5a88"

    var latitude = ""
    var longitude = ""
    
    var photosSearchURL: URL {
        return flickrURL(endPoint: .photosSearch,
                         parameters: ["extras": "url_z,date_taken,geo,views"])
    }
    
    /// The Flickr API init to get photos for a supploed lat and long
    /// - Parameters:
    ///   - lat: latitude of the location to get photos for
    ///   - lon: longitude of the location get the photos for
    init(lat:Double, lon: Double) {
        self.latitude = String(lat)
        self.longitude = String(lon)
    }
    
    /// A function to set up the Flickr URL to get photos from
    /// - Parameters:
    ///   - endPoint: the end point we try to hit
    ///   - parameters: additional params to be added if any
    /// - Returns: a URL after adding all of the params and end point
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
    
    /// A funtion that decodes the response and return an array of photos
    /// - Parameter data: the data to decode
    /// - Returns: the array of decoded photos from Flickr
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
    
}

