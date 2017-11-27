//
//  SelfieEdtiorViewController.swift
//  Everyday
//
//  Created by Mathieu Tozer on 11/27/17.
//  Copyright © 2017 Mathieu Tozer. All rights reserved.
//

import Cocoa

class SelfieEdtiorViewController: NSViewController {
  
  @IBOutlet var images: NSArrayController?
  
  @objc dynamic var managedObjectContext: NSManagedObjectContext {
    get {
      return (NSApp.delegate as! AppDelegate).persistentContainer.viewContext
    }
  }
  
  @objc dynamic var selectedIndex: Int = 0 {
    didSet {
      images?.setSelectionIndex(selectedIndex)
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
