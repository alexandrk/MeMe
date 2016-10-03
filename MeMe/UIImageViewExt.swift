//
//  UIImageViewExt.swift
//  MeMe
//
//  Created by Alexander on 10/2/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    var scaledImageDimensions: CGSize {
        
        let frameWidth  = Double(self.frame.size.width)
        let frameHeight = Double(self.frame.size.height)
        let imgWidth    = Double(self.image!.size.width)
        let imgHeight   = Double(self.image!.size.height)
        
        let sx = frameWidth / imgWidth
        let sy = frameHeight / imgHeight
        
        //switch (self.contentMode) {
        //case .scaleAspectFit:
            
        if imgWidth > imgHeight {
            return CGSize (width: frameWidth, height: sx * imgHeight)
        }
        else {
            return CGSize (width: sy * imgWidth, height: frameHeight)
        }
        
        //default:
        //    return CGSize(width:s, height:s)
        //}
    }
}
