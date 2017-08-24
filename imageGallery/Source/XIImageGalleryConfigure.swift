//
//  XIImageGalleryConfigure.swift
//  imageGallery
//
//  Created by 陳建佑 on 18/08/2017.
//  Copyright © 2017 陳建佑. All rights reserved.
//

import Foundation
import UIKit

public class XIImageGalleryConfigure {

    /// Scroll direction when multiple images showed
    public var direction: UIPageViewControllerNavigationOrientation = .horizontal
    
    /// Max image zoom scale
    public var maximumZoomScale: CGFloat = 5.0
    
    /// Min image zoom scale
    public var minimumZoomScale: CGFloat = 1.0
    
    /// Show download button or not
    public var allowDownload: Bool = true
    
    /// Can infinite scroll or not
    public var infiniteScroll: Bool = true
    
    /// Top function view background color
    public var funcViewColor: UIColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.6)
    
    /// function button color
    public var funcBtnColor: UIColor = UIColor.white
    
    /// background color of view
    public var backgroundColor: UIColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 1)
    
    public init() {}
}
