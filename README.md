# XIImageGallery    
A simple image gallery based on `UIPageViewController`    
![](https://github.com/xxi511/XIImageGallery/blob/master/demo.gif)    

## Requirements        
* iOS 10+    
* Swift 3    

## Install    
### Carthage     
Add `github "xxi511/XIImageGallery"` to your `Cartfile`    

### Manual    
Add files in [source](https://github.com/xxi511/XIImageGallery/tree/master/imageGallery/Source) to your project

## How to use    
```
import XIImageGallery

let vi = XIImageGalleryVC(XIImageGalleryConfigure(), sources: [UIImage(named: "dog"), UIImage(named: "icon")])
self.present(vi, animated: true, completion: nil)
```

`UIImage`, `URL`, `String` are accepted for `sources`       
but I'm highly recommend send `UIImage` only, since I don't do any effort about image download and cache     
if the image download failed, I show failed label on screen, as like gif showed

There are some option you can set by `XIImageGalleryConfigure`, [take a look](https://github.com/xxi511/XIImageGallery/blob/master/imageGallery/Source/XIImageGalleryConfigure.swift)
