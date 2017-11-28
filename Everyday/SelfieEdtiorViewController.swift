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
  
  @objc dynamic var managedObjectContext: NSManagedObjectContext {
    get {
      return (NSApp.delegate as! AppDelegate).persistentContainer.viewContext
    }
  }
  
  @objc dynamic var selectedIndex: Int = 0 {
    didSet {
      images?.setSelectionIndex(selectedIndex)
      if let i = images.selectedObjects.first as? Image {
        selfiView.image = i.img
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let pan = NSPanGestureRecognizer(target: self, action: #selector(SelfieEdtiorViewController.drag(pan:)))
    self.baseView.gestureRecognizers = [pan]
  }
  
  @objc func drag(pan: NSPanGestureRecognizer) {
    print(pan.location(in: self.view))
  }
  
  override func mouseDown(with event: NSEvent) {
    
  }
    
}
