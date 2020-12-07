//
//  APITests.swift
//  iFlickrTests
//
//  Created by Abdullah Alseddiq on 12/4/20.
//

import XCTest
@testable import iFlickr

class APITests: XCTestCase {

    //Test to make sure photos only with URL will be in the array of the result after making a fetch
    func testPhotosWithURL() {
       let store = PhotoStore()
       var photosArray = [Photo]()

        let completionExpectation = expectation(description: "Execute completion closure.")
       store.fetchPhotosForLocation(lat: 26.4207, lon: 50.0888) {
        (photosResult) in
        switch photosResult {
        case let .success(photos):
            photosArray = photos
        case let .failure(error):
            print("Error fetching photos: \(error)")
            photosArray.removeAll()
        }

        for photo in photosArray {
            XCTAssertNotNil(photo.remoteURL)
        }
        completionExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)

    }
    
    
    /// A test to verify that Flickr API get photos that were geo tagged, -> have latitiude and lontitude
    func testPhotosWithGeo() {
       let store = PhotoStore()
       var photosArray = [Photo]()

        let completionExpectation = expectation(description: "Execute completion closure.")
       store.fetchPhotosForLocation(lat: 26.4207, lon: 50.0888) {
        (photosResult) in
        switch photosResult {
        case let .success(photos):
            photosArray = photos
        case let .failure(error):
            print("Error fetching photos: \(error)")
            photosArray.removeAll()
        }

        for photo in photosArray {
            XCTAssertNotEqual(photo.latitude.count, 0, "checked")
        }
        completionExpectation.fulfill()
        }

        waitForExpectations(timeout: 10.0, handler: nil)

    }
    
    
}
