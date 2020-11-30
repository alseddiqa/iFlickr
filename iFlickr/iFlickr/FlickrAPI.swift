//
//  FlickrAPI.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 11/29/20.
//

import Foundation

enum EndPoint: String {
    case photosSearch = "flickr.photos.search"
}

struct FlickrResponse: Codable {
    //let photos: FlickrPhotosResponse
    let photosInfo: FlickrPhotosResponse
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}
struct FlickrPhotosResponse: Codable {
    let photos: [Photo]
    enum CodingKeys: String, CodingKey {
        case photos = "photo"
    }
}

struct FlickrAPI {
    
    let baseURLString = "https://api.flickr.com/services/rest"
    let apiKey = "a6d819499131071f158fd740860a5a88"

    var lat = ""
    var lon = ""
    
    var photosSearchURL: URL {
        return flickrURL(endPoint: .photosSearch,
                         parameters: ["extras": "url_z,date_taken"])
    }
    
    init(lat:Double, lon: Double) {
        self.lat = String(lat)
        self.lon = String(lon)
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
            "lat": lat,
            "lon": lon
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
    
}
