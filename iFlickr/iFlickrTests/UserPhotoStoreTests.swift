//
//  UserPhotoStoreTests.swift
//  iFlickrTests
//
//  Created by Abdullah Alseddiq on 12/4/20.
//

import XCTest
@testable import iFlickr

class UserPhotoStoreTests: XCTestCase {
    

    //Test photo insertiopn
    //Successul insertion was also verified from DB
    func testPhotoInsertion() {
        let id = "BaAy9BWQADe8mgUDHOa6xhg4FF82"
        let userPhotoStore = UserPhotoStore(userId: id)
        let photo = SavedPhoto(id: "50666290098", title: "FlickrApiCapstone", views: "13", date: "12-01-2020 07:45")
        photo.photoLink = URL(string: "https://live.staticflickr.com/65535/50666290098_76c14706f7_z.jpg")
        let photosCountBeforeInsertion = userPhotoStore.favoritePhotos.count
        userPhotoStore.addPhotoToList(photo: photo)
        XCTAssertEqual(userPhotoStore.favoritePhotos.count , photosCountBeforeInsertion + 1)
    }
    
    //Test if photo search works
    func testPhotoExistance() {
        let id = "BaAy9BWQADe8mgUDHOa6xhg4FF82"
        let userPhotoStore = UserPhotoStore(userId: id)
        let photo = SavedPhoto(id: "999999111111", title: "Thank you Lama 🎈♥️", views: "28", date: "10-17-2020 00:24")
        photo.photoLink = URL(string: "https://live.staticflickr.com/65535/50666290098_76c14706f7_z.jpg")
        userPhotoStore.addPhotoToList(photo: photo)
        userPhotoStore.loadPhotos(forId: id)
        let exist = userPhotoStore.checkIfPhotoExist(photo: photo)
        XCTAssertTrue(exist)
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            userPhotoStore.loadPhotos(forId: )
//        }
//    }

}
