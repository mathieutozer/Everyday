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
  @IBOutlet weak var baseView: NSView!
  @IBOutlet weak var dateLabel: NSView!
  @IBOutlet weak var xLabel: NSTextField!
  @IBOutlet weak var yLabel: NSTextField!
  
  var playing: Bool = false
  
  var timer: Timer?
  
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
  
  func layoutImage(_ image: NSImage, xi: Float, xj: Float) {

    // size the image view to be max size given the images aspect ratio
    let imageSize = image.size
    
    var rx = 0.0 as CGFloat
    rx = 1.0/(imageSize.height / imageSize.width)
    let newWidth = self.baseView.frame.size.height * rx
    var frame = self.view.frame
    frame.origin.y = 0
    frame.size.height = self.baseView.frame.size.height
    frame.size.width = newWidth
    frame.origin.x = (self.baseView.frame.size.width - newWidth) / 2
    selfiView.frame = frame
    
    var labelFrame = dateLabel.frame
    frame.origin.y = frame.origin.y + 20
    labelFrame.origin = frame.origin
    labelFrame.size.width = frame.width
    dateLabel.frame = labelFrame
    
    if !playing {
      return
    }
    selfiView.image = image
    
    if xj != 0 {
      //1/(100/(100-25))
      let xi = CGFloat(xi)
      let xj = CGFloat(xj)
      // how much do we have to translate by
      let leftEyeInSelfieView = CGPoint(x: selfiView.frame.width * xi, y: selfiView.frame.height * xj)
      
      let p = CGPoint(x: CGFloat(xLabel.floatValue), y: CGFloat(yLabel.floatValue))
      
      let xOffset = p.x - leftEyeInSelfieView.x
      let yOffset = p.y - leftEyeInSelfieView.y
      
      var offsetFrame = selfiView.frame
      offsetFrame.origin.x = offsetFrame.origin.x + xOffset
      offsetFrame.origin.y = offsetFrame.origin.y + yOffset
      selfiView.frame = offsetFrame
    }
  }
  
  @objc dynamic var selectedIndex: Int = 0 {
    didSet {
      images?.setSelectionIndex(selectedIndex)
      if let i = images.selectedObjects.first as? Image {
        layoutImage(i.img(), xi: i.xi, xj: i.xj)
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let pan = NSPanGestureRecognizer(target: self, action: #selector(SelfieEdtiorViewController.drag(pan:)))
    self.baseView.gestureRecognizers = [pan]
    
    images.sortDescriptors = [NSSortDescriptor(key: "dateTaken", ascending: true)]
    
    let image = #imageLiteral(resourceName: "badge1")
    self.layoutImage(image, xi: 0, xj: 0)
  }
  
  
  @IBAction func play(_ sender: Any?) {
    playing = true
    timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true, block: { (timer) in
      if self.selectedIndex <= (self.images.arrangedObjects as! [Any]).count - 1 {
        self.selectedIndex += 1
      } else {
        self.timer?.invalidate()
        let image = #imageLiteral(resourceName: "badge2")
        self.layoutImage(image, xi: 0, xj: 0)
      }
      
    })
  }
  
  @objc func drag(pan: NSPanGestureRecognizer) {
    layoutImage(selfiView.image!, xi: 0, xj: 0)
  }
  
  override func mouseDown(with event: NSEvent) {
    
  }
    
}

extension Image {
  func computeOffset() -> Bool {
    let context = CIContext()
    let options = [CIDetectorAccuracy : CIDetectorAccuracyHigh]
    let detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
    let coreImage = self.coreImage
    let nsImage = self.img
    
    if let features = detector?.features(in: coreImage()).first as? CIFaceFeature {  
      // size the image view to be max size given the images aspect ratio
      let imageSize = nsImage().size
      
      self.xi = Float(1.0/(imageSize.width / features.leftEyePosition.x))
      self.xj = Float(1.0/(imageSize.height / (features.leftEyePosition.y)))
      return true
    }
    return false
  }
}
