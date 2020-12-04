//
//  UserPhotoStoreTests.swift
//  iFlickrTests
//
//  Created by Abdullah Alseddiq on 12/4/20.
//

import XCTest
@testable import iFlickr

class UserPhotoStoreTests: XCTestCase {

   let userPhotoStore = UserPhotoStore()

    //test photo deletion
    func testPhotoDeletion() {
        let photo = SavedPhoto(id: "50666290098", title: "FlickrApiCapstone", views: "13", date: "12-01-2020 07:45")
        let photosCountBeforDeletion = userPhotoStore.favoritePhotos.count
        userPhotoStore.deletePhotoFromList(photo: photo)
        XCTAssertEqual(userPhotoStore.favoritePhotos.count - 1 , photosCountBeforDeletion)
    }
    
    //Test if photo search works
    func testPhotoExistance() {
        let photo = SavedPhoto(id: "49220790023", title: "Mosque Al Dhaid", views: "8027", date: "12-11-2019 17:33")
        let exist = userPhotoStore.checkIfPhotoExist(photo: photo)
        XCTAssertTrue(exist)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
