//
//  Meme.swift
//  MeMe
//
//  Created by Alexander on 10/31/16.
//  Copyright © 2016 Dictality. All rights reserved.
//

import Foundation
import UIKit


/*
 Meme struct - keeps all the info about the meme
 - both text strings (top and bottom)
 - original image
 - meme image, with text strings applied to the image
 Note: currently not used
 */
struct Meme {
    var textTop : String
    var textBottom : String
    var imageOriginal : UIImage
    var imageMemed : UIImage
}
