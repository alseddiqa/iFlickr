//
//  FlickrResponse.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/5/20.
//

import Foundation

struct FlickrResponse: Codable {
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
