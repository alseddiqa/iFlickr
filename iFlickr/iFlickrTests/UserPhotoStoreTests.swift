//
//  UserPhotoStoreTests.swift
//  iFlickrTests
//
//  Created by Abdullah Alseddiq on 12/4/20.
//

import XCTest
@testable import iFlickr

class UserPhotoStoreTests: XCTestCase {
    
    var userPhotoStore = UserPhotoStore()

    //Test photo insertiopn
    //Successul insertion was also verified from DB
//    func testPhotoInsertion() {
//        let photo = SavedPhoto(id: "50666290098", title: "FlickrApiCapstone", views: "13", date: "12-01-2020 07:45")
//        photo.photoLink = URL(string: "https://live.staticflickr.com/65535/50666290098_76c14706f7_z.jpg")
//        let photosCountBeforeInsertion = userPhotoStore.favoritePhotos.count
//        userPhotoStore.addPhotoToList(photo: photo)
//        XCTAssertEqual(userPhotoStore.favoritePhotos.count , photosCountBeforeInsertion + 1)
//    }
    
    //Test if photo search works
    func testPhotoExistance() {
        let photo = SavedPhoto(id: "999999111111", title: "Thank you Lama 🎈♥️", views: "28", date: "10-17-2020 00:24")
        
        let exist = userPhotoStore.checkIfPhotoExist(photo: photo)
        XCTAssertTrue(exist)
    }

    //test photo deletion
    //Successul deletion was also verified from DB
//    func testPhotoDeletion() {
//        let photo = SavedPhoto(id: "50625334727", title: "Potentialities and Limitations.", views: "2171", date: "11-09-2020 17:03")
//        let photosCountBeforeDeletion = userPhotoStore.favoritePhotos.count
//        userPhotoStore.deletePhotoFromList(photo: photo)
//        XCTAssertEqual(photosCountBeforeDeletion - 1 , userPhotoStore.favoritePhotos.count)
//    }
    

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            userPhotoStore.loadPhotos(forId: )
//        }
//    }

}
