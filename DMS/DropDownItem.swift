//
//  VacType.swift
//  VMS
//
//  Created by Mohamed Fadl on 12/10/15.
//  Copyright © 2015 Compulink. All rights reserved.
//

import Foundation

class DropDownItem:NSObject {
    var idx:String
    var title:String
    
    public init(idx:String, title:String){
        self.idx = idx
        self.title = title
    }
    
//    required override public init() { // <== Need "required" because we need to call dynamicType() below
//        self.idx = 0;
//        self.title = "";
//    }
//    public func copyWithZone(zone: NSZone) -> AnyObject { // <== NSCopying
//        // *** Construct "one of my current class". This is why init() is a required initializer
//        let theCopy = self.dynamicType.init()
//        theCopy.idx = self.idx;
//        theCopy.title = self.title;
//        return theCopy
//    }
    
}