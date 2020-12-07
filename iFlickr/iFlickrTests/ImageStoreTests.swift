//
//  ImageStoreTests.swift
//  iFlickrTests
//
//  Created by Abdullah Alseddiq on 12/7/20.
//

import XCTest
@testable import iFlickr

class ImageStoreTests: XCTestCase {

    func testImageCaching() {
        let imageStore = ImageStore()
        let image = UIImage(systemName: "star.fill")
        imageStore.setImage(image!, forKey: "123456789")
        let check = imageStore.image(forKey: "123456789")
        XCTAssertNotNil(check)
    }
    
    func testImageDeletionFromCache() {
        let imageStore = ImageStore()
        let image = UIImage(systemName: "star.fill")
        imageStore.setImage(image!, forKey: "123456789")
        let check = imageStore.image(forKey: "123456789")
        XCTAssertNotNil(check)
        imageStore.deleteImageFromCache(forKey: "123456789")
        let nilImage = imageStore.image(forKey: "123456789")
        XCTAssertNil(nilImage)
    }
}
