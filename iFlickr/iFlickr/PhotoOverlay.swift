//
//  PhotoOverlay.swift
//  iFlickr
//
//  Created by Abdullah Alseddiq on 12/1/20.
//

import UIKit
import MapKit
import CoreLocation

//class PhotoOverlay : NSObject, MKOverlay {
//
////    let image:UIImage
////    let boundingMapRect: MKMapRect
////    let coordinate:CLLocationCoordinate2D
////
////    init(image: UIImage, rect: MKMapRect) {
////        self.image = image
////        self.boundingMapRect = rect
////        self.coordinate = 
////    }
//}
//
//class ImageOverlayRenderer : MKOverlayRenderer {
//
//    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
//
//        guard let overlay = self.overlay as? PhotoOverlay else {
//            return
//        }
//
//        let rect = self.rect(for: overlay.boundingMapRect)
//
//        UIGraphicsPushContext(context)
//        overlay.image.draw(in: rect)
//        UIGraphicsPopContext()
//    }
//}
