//
//  SelfieView.swift
//  Everyday
//
//  Created by Mathieu Tozer on 11/27/17.
//  Copyright © 2017 Mathieu Tozer. All rights reserved.
//

import Cocoa
import PathKit

class SelfieView: NSImageView {
  var imageModel: Image? {
    didSet {
      super.image = imageModel?.img()
    }
  }
}

extension Image {
  func img() -> NSImage {
      let path = Path("~/Desktop/Selfies/\(self.filename ?? "")").absolute().string
      let image = NSImage(contentsOfFile: path)
      return image!
  }
  
  func coreImage() -> CIImage {
      let image = self.img().tiffRepresentation
      let bitmap = NSBitmapImageRep(data: image!)
      let core = CIImage(bitmapImageRep: bitmap!)
      return core!
  }
}
