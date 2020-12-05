//
//  PhotoStoreTests.swift
//  iFlickrTests
//
//  Created by Abdullah Alseddiq on 12/5/20.
//

import XCTest
@testable import iFlickr

class PhotoStoreTests: XCTestCase {
    
    //test performance of the fetch
    func testPerformance() {
       let store = PhotoStore()
       var photosArray = [Photo]()

        let completionExpectation = expectation(description: "Execute fetch call")
        self.measure {
            store.fetchPhotosForLocation(lat: 26.4207, lon: 50.0888) {
             (photosResult) in
             switch photosResult {
             case let .success(photos):
                 photosArray = photos
             case let .failure(error):
                 print("Error fetching photos: \(error)")
                 photosArray.removeAll()
             }
             
             completionExpectation.fulfill()
             }
        }
       
        waitForExpectations(timeout: 10.0, handler: nil)

    }
    
}
