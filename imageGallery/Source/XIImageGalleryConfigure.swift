//
//  XIImageGalleryConfigure.swift
//  imageGallery
//
//  Created by 陳建佑 on 18/08/2017.
//  Copyright © 2017 陳建佑. All rights reserved.
//

import Foundation
import UIKit

class XIImageGalleryConfigure {

    /// Scroll direction when multiple images showed
    var direction: UIPageViewControllerNavigationOrientation = .horizontal
    
    /// Max image zoom scale
    var maximumZoomScale: CGFloat = 5.0
    
    /// Min image zoom scale
    var minimumZoomScale: CGFloat = 1.0
    
    /// Show download button or not
    var allowDownload: Bool = true
    
    /// Can infinite scroll or not
    var infiniteScroll: Bool = true
    
    /// Top function view background color
    var funcViewColor: UIColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
    
    /// function button color
    var funcBtnColor: UIColor = UIColor.white
    
    /// background color of view
    var backgroundColor: UIColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
}
