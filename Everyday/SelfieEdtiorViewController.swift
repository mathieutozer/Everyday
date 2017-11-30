//
//  SelfieEdtiorViewController.swift
//  Everyday
//
//  Created by Mathieu Tozer on 11/27/17.
//  Copyright © 2017 Mathieu Tozer. All rights reserved.
//

import Cocoa

class SelfieEdtiorViewController: NSViewController {

  
  @IBOutlet var images: NSArrayController!
  @IBOutlet weak var selfiView: NSImageView!
  
  @IBOutlet weak var leftEye: NSImageView!
  @IBOutlet weak var rightEye: NSImageView!
  @IBOutlet weak var baseView: NSView!
  
  @objc dynamic var selectionIndexes: NSIndexSet? {
    didSet {
      selectedIndex = selectionIndexes?.firstIndex ?? 0
    }
  }
  
  @objc dynamic var managedObjectContext: NSManagedObjectContext {
    get {
      return (NSApp.delegate as! AppDelegate).persistentContainer.viewContext
    }
  }
  
  @objc dynamic var selectedIndex: Int = 0 {
    didSet {
      images?.setSelectionIndex(selectedIndex)
      if let i = images.selectedObjects.first as? Image {
        let context = CIContext()
        let options = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        let coreImage = i.coreImage
        let nsImage = i.img
        if let features = detector?.features(in: coreImage).first as? CIFaceFeature {
          
          // size the image view to be max size given the images aspect ratio
          let imageSize = nsImage.size
          
          var rx = 0.0 as CGFloat
          rx = 1.0/(imageSize.height / imageSize.width)
          let newWidth = self.baseView.frame.size.height * rx
          var frame = self.view.frame
          frame.origin.y = 0
          frame.size.height = self.baseView.frame.size.height
          frame.size.width = newWidth
          frame.origin.x = (self.baseView.frame.size.width - newWidth) / 2
          selfiView.frame = frame
          //1/(100/(100-25))
          let xi = 1.0/(imageSize.width / features.leftEyePosition.x)
          let xj = 1.0/(imageSize.height / (features.leftEyePosition.y))
          
          selfiView.image = i.img
          
          // how much do we have to translate by
          let leftEyeInSelfieView = CGPoint(x: selfiView.frame.width * xi, y: selfiView.frame.height * xj)
          print(leftEyeInSelfieView) /// <<< CORRECT
          
          let p = leftEye.frame.origin
          //let p = self.view.convert(leftEyeOrigin, to: selfiView)
          print(p)
          
          let xOffset = p.x - leftEyeInSelfieView.x
          let yOffset = p.y - leftEyeInSelfieView.y
          
          
          var offsetFrame = selfiView.frame
          offsetFrame.origin.x = offsetFrame.origin.x + xOffset
          offsetFrame.origin.y = offsetFrame.origin.y + yOffset
          
         // print(offsetFrame)
          
          selfiView.frame = offsetFrame
          

          //print(CGPoint(x: xOffset, y: yOffset))
          
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let pan = NSPanGestureRecognizer(target: self, action: #selector(SelfieEdtiorViewController.drag(pan:)))
    self.baseView.gestureRecognizers = [pan]
    
    images.sortDescriptors = [NSSortDescriptor(key: "dateTaken", ascending: true)]
    
  }
  
  @objc func drag(pan: NSPanGestureRecognizer) {
    print(pan.location(in: self.view))
  }
  
  override func mouseDown(with event: NSEvent) {
    
  }
    
}
