//
//  XIImageDisplayVC.swift
//  imageGallery
//
//  Created by 陳建佑 on 18/08/2017.
//  Copyright © 2017 陳建佑. All rights reserved.
//

import UIKit

class XIImageDisplayVC: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    fileprivate var progress = UIProgressView()
    let imageView = UIImageView()
    fileprivate var maxiumZoom: CGFloat?
    fileprivate var minimumZoom: CGFloat?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(_ source: Any, maxiumZoom: CGFloat, minimumZoom: CGFloat, backgroundColor: UIColor) {
        self.init(nibName: "XIImageDisplayVC", bundle: Bundle(for: XIImageDisplayVC.self))
        
        if let img = source as? UIImage {
            self.imageView.image = img
        }
        else if let url = source as? URL {
            let sess = self.sessInit()
            sess.downloadTask(with: url).resume()
        }
        else {
            assert(false, "Error source type")
        }
        self.maxiumZoom = maxiumZoom
        self.minimumZoom = minimumZoom
        self.view.backgroundColor = backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.imageView.image != nil) ? self.viewInit(): self.progressViewInit()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension XIImageDisplayVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let fSize = self.scrollView.frame.size
        let cSize = self.scrollView.contentSize
        let ctr_x = (fSize.width > cSize.width) ? 0.5 * fSize.width: 0.5 * cSize.width
        let ctr_y = (fSize.height > cSize.height) ? 0.5 * fSize.height: 0.5 * cSize.height
        self.imageView.center = CGPoint(x: ctr_x, y: ctr_y)
    }
}

extension XIImageDisplayVC: URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            let percent = Float(totalBytesWritten / totalBytesExpectedToWrite)
            self.progress.progress = percent
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            if let img = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = img
                    self.progress.removeFromSuperview()
                    self.viewInit()
                }
            }
            else {self.showErrorLabel()}
        }
        catch {self.showErrorLabel()}
    }
}

// MARK: func
extension XIImageDisplayVC {

    func viewInit() {
        self.scrollView.maximumZoomScale = self.maxiumZoom!
        self.scrollView.minimumZoomScale = self.minimumZoom!
        
        let screen = UIScreen.main.bounds.size
        let size = self.suitableSize()
        self.scrollView.contentSize = size
        self.imageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.imageView.center = CGPoint(x: 0.5 * screen.width, y: 0.5 * screen.height)
        self.scrollView.addSubview(self.imageView)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.zoomImage))
        doubleTap.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTap)
    }
    
    func progressViewInit() {
        self.progress.progressTintColor = UIColor.white
        self.progress.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(self.progress, at: 999)
        let ctr_y = NSLayoutConstraint(item: self.progress, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        let ctr_x = NSLayoutConstraint(item: self.progress, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: self.progress, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.7, constant: 0)
        self.view.addConstraints([ctr_x, ctr_y, width])
    }
    
    func sessInit() -> URLSession {
        let sess = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        return sess
    }
    
    func showErrorLabel() {
        DispatchQueue.main.async {
            self.progress.removeFromSuperview()
            let err = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 33))
            err.backgroundColor = UIColor(colorLiteralRed: 80/255, green: 80/255, blue: 80/255, alpha: 1)
            err.textColor = UIColor.white
            err.textAlignment = .center
            err.layer.cornerRadius = 15
            err.layer.masksToBounds = true
            let screen = UIScreen.main.bounds
            err.center = CGPoint(x: 0.5 * screen.width, y: 0.5 * screen.height)
            err.text = "download failed"
            
            self.view.insertSubview(err, at: 999)
        }
        
    }
    
    func suitableSize() -> CGSize {
        var size = CGSize.zero
        let screen = UIScreen.main.bounds.size
        guard let imgSize = self.imageView.image?.size else {return size}
        let imgRatio = imgSize.height / imgSize.width
        
        if screen.height >= imgSize.height && screen.width >= imgSize.width {
            size = imgSize
        }
        else if imgSize.height >= imgSize.width {
            let nh = screen.height
            let nw = nh / imgRatio
            size = CGSize(width: nw, height: nh)
        }
        else {
            let nw = screen.width
            let nh = nw * imgRatio
            size = CGSize(width: nw, height: nh)
        }
        
        return size
    }

    func zoomImage() {
        let max = self.scrollView.maximumZoomScale
        let min = self.scrollView.minimumZoomScale
        let scale = self.scrollView.zoomScale
        let newScale = (scale == max) ? min: max
        self.scrollView.setZoomScale(newScale, animated: true)
    }
}
