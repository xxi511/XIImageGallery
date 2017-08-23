//
//  ViewController.swift
//  imageGallery
//
//  Created by 陳建佑 on 18/08/2017.
//  Copyright © 2017 陳建佑. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickBtn(_ sender: Any) {
//        let vi = XIImageDisplayVC(#imageLiteral(resourceName: "dog"))
//        self.present(vi, animated: true, completion: nil)
        
        let url = URL(string: "https://cdn.pixabay.com/photo/2016/03/28/12/35/cat-1285634_960_720.png")!
        let str = "https://www.w3schools.com/css/trolltunga.jpg"
        let str2 = "https://stackoverflow.com/questions/23987692/showing-the-file-download-progress-with-nsurlsessiondatatask"
        let cfg = XIImageGalleryConfigure()
        cfg.direction = .horizontal
        let vi = XIImageGalleryVC(cfg, sources: [#imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "icon"), url, str, str2])
        self.present(vi, animated: true, completion: nil)
    }

}

