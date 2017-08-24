//
//  XIImageGalleryVC.swift
//  imageGallery
//
//  Created by 陳建佑 on 18/08/2017.
//  Copyright © 2017 陳建佑. All rights reserved.
//

import UIKit

public class XIImageGalleryVC: UIPageViewController {
    fileprivate var cfg: XIImageGalleryConfigure = XIImageGalleryConfigure()
    fileprivate var sources: [Any]? = nil
    
    fileprivate var topConstraint: NSLayoutConstraint?
    fileprivate let msg = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 33))
    fileprivate var funcView = UIView()
    fileprivate var firstIdx = 0
    fileprivate var vis:[XIImageDisplayVC] = []
    
    // MARK: Initialize
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
        self.cfg.direction = navigationOrientation
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Not Implent")
    }
    
    /// Initialize image gallery view controller
    ///
    /// - Parameters:
    ///   - configure: gallery configure
    ///   - sources: source array, UIImage, String, URL is accept, but I super recommand send UIImage only
    ///   - firstShowIdx: The index of first showed images in sources
    convenience public init(_ configure: XIImageGalleryConfigure, sources: [Any], firstShowIdx: Int=0) {
        self.init(transitionStyle: .scroll, navigationOrientation: configure.direction, options: nil)
        self.delegate = self
        self.dataSource = self
        self.cfg = configure
        self.sources = sources
        self.firstIdx = (sources.count > firstShowIdx) ? firstShowIdx: 0
        self.funcViewInit()
        self.msgLabelInit()
    }
    
    

    override  public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = self.cfg.backgroundColor
        let filted = self.sources?.filter{$0 is UIImage || $0 is URL || $0 is String}
        
        for item in filted! {
            if let str = item as? String {
                if let url = URL(string: str) {
                    self.appendVis(source: url)
                }
            }
            else {
                self.appendVis(source: item)
            }
        }
        self.setViewControllers([vis[self.firstIdx]], direction: .forward, animated: false, completion: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapView))
        self.view.addGestureRecognizer(tap)
    }

    override  public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: pageViewController Delegate
extension XIImageGalleryVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let idx = self.vis.index(where: {$0 == viewController})!
        let outVi = (self.cfg.infiniteScroll) ? vis.last: nil
        return (idx > 0) ? vis[idx - 1]: outVi
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let idx = self.vis.index(where: {$0 == viewController})!
        let outVi = (self.cfg.infiniteScroll) ? vis.first: nil
        return (self.vis.count - 1 > idx) ? vis[idx + 1]: outVi
    }
}

// MARK: function view initialize
extension XIImageGalleryVC {
    func msgLabelInit() {
        self.msg.backgroundColor = UIColor(colorLiteralRed: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        self.msg.textColor = UIColor.white
        self.msg.textAlignment = .center
        self.msg.layer.cornerRadius = 15
        self.msg.layer.masksToBounds = true
        
        let screen = UIScreen.main.bounds.size
        self.msg.center = CGPoint(x: 0.5 * screen.width, y: screen.height - 100)
    }
    
    func funcViewInit() {
        self.funcView.backgroundColor = self.cfg.funcViewColor
        self.funcView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.funcView)
        self.topConstraint = NSLayoutConstraint(item: self.funcView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: self.funcView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self.funcView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: self.funcView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64)
        self.view.addConstraints([self.topConstraint!, left, right, height])
        
        if self.cfg.allowDownload {
            self.downloadViewInit()
        }
        
        self.dismissViewInit()
    }
    
    func downloadViewInit() {
        let downloadView = UIView()
        downloadView.translatesAutoresizingMaskIntoConstraints = false
        let arrow = self.arrow(from: CGPoint(x: 22, y: 10), to: CGPoint(x: 22, y: 35), tailWidth: 12, headWidth: 25, headLength: 12)
        let arrowLayer = CAShapeLayer()
        arrowLayer.path = arrow.cgPath
        arrowLayer.fillColor = self.cfg.funcBtnColor.cgColor
        downloadView.layer.addSublayer(arrowLayer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.saveImage))
        downloadView.addGestureRecognizer(tap)
        
        self.funcView.addSubview(downloadView)
        let right = NSLayoutConstraint(item: downloadView, attribute: .trailing, relatedBy: .equal, toItem: self.funcView, attribute: .trailing, multiplier: 1, constant: -10)
        let bottom = NSLayoutConstraint(item: downloadView, attribute: .bottom, relatedBy: .equal, toItem: self.funcView, attribute: .bottom, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: downloadView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        let width = NSLayoutConstraint(item: downloadView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        self.funcView.addConstraints([right, bottom, height, width])
    }
    
    func dismissViewInit() {
        let dismissView = UIView()
        dismissView.translatesAutoresizingMaskIntoConstraints = false
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 9.5, y: 9.5))
        path.addLine(to: CGPoint(x: 34.5, y: 34.5))
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x: 34.5, y: 9.5))
        path2.addLine(to: CGPoint(x: 9.5, y: 34.5))
        
        let layer1 = CAShapeLayer()
        layer1.path = path.cgPath
        layer1.lineWidth = 3
        layer1.strokeColor = self.cfg.funcBtnColor.cgColor
        
        let layer2 = CAShapeLayer()
        layer2.path = path2.cgPath
        layer2.lineWidth = 3
        layer2.strokeColor = self.cfg.funcBtnColor.cgColor
        
        dismissView.layer.addSublayer(layer1)
        dismissView.layer.addSublayer(layer2)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissGallery))
        dismissView.addGestureRecognizer(tap)
        
        self.funcView.addSubview(dismissView)
        let left = NSLayoutConstraint(item: dismissView, attribute: .leading, relatedBy: .equal, toItem: self.funcView, attribute: .leading, multiplier: 1, constant: 10)
        let bottom = NSLayoutConstraint(item: dismissView, attribute: .bottom, relatedBy: .equal, toItem: self.funcView, attribute: .bottom, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: dismissView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        let width = NSLayoutConstraint(item: dismissView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        self.funcView.addConstraints([left, bottom, height, width])
    }
    
    func arrow(from start: CGPoint, to end: CGPoint, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> UIBezierPath {
        let length = hypot(end.x - start.x, end.y - start.y)
        let tailLength = length - headLength
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        let points: [CGPoint] = [
            p(0, tailWidth / 2),
            p(tailLength, tailWidth / 2),
            p(tailLength, headWidth / 2),
            p(length, 0),
            p(tailLength, -headWidth / 2),
            p(tailLength, -tailWidth / 2),
            p(0, -tailWidth / 2)
        ]
        
        let cosine = (end.x - start.x) / length
        let sine = (end.y - start.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
        let path = CGMutablePath()
        path.addLines(between: points, transform: transform)
        path.closeSubpath()
        return UIBezierPath.init(cgPath: path)
    }
}

// MARK: func
extension XIImageGalleryVC {
    func saveImage() {
        // TODO show download toast
        let vi = self.viewControllers?.first as? XIImageDisplayVC
        let img: UIImage? = vi?.imageView.image
        
        if img != nil {
            UIImageWriteToSavedPhotosAlbum(img!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        else {
            self.showToast(str: "Failed")
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        let saveMsg = (error == nil) ? "Succeed": "Failed"
        self.showToast(str: saveMsg)
    }
    
    func showToast(str: String) {

        self.msg.text = str
        self.view.insertSubview(self.msg, at: 999)
        self.perform(#selector(self.dismissMsgToast), with: nil, afterDelay: 3)
    }
    
    func dismissGallery() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapView() {
        let constant = self.topConstraint?.constant
        self.topConstraint?.constant = (constant == 0) ? -64: 0
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func dismissMsgToast() {
        self.msg.removeFromSuperview()
    }
    
    func appendVis(source: Any) {
        let vi = XIImageDisplayVC(source, maxiumZoom: self.cfg.maximumZoomScale, minimumZoom:self.cfg.minimumZoomScale, backgroundColor:self.cfg.backgroundColor)
        self.vis.append(vi)
    }
}
