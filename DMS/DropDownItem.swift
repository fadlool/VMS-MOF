//
//  DropDownItem.swift
//  CRS
//
//  Created by Mohamed Fadl on 12/23/14.
//  Copyright (c) 2014 Compulink. All rights reserved.
//

import Foundation

public class DropDownItem:NSObject {
    
    var id_:Int
    var type:Int
    var arabicName:String
    var englishName:String
    var telegramSendingWay:Bool
    var language:Int
    
    
    public init( id_:Int,  arabicName:String,  englishName:String,  language:Int) {
        self.id_ = id_
        self.arabicName = arabicName
        self.englishName = englishName
        self.language = language
        self.type  = 0
        self.telegramSendingWay = false
        
    }
    public init( id_:Int, type:Int,  arabicName:String,  englishName:String,  language:Int) {
        self.id_ = id_
        self.arabicName = arabicName
        self.englishName = englishName
        self.language = language
        self.type  = type
        self.telegramSendingWay = false
        
    }
    override public func isEqual(object: AnyObject?) -> Bool { // for NSArrays and NSDictionaries
        if let dropDownItem = object as? DropDownItem {
            // just use our "==" function
            return (dropDownItem.id_ == self.id_ && dropDownItem.type == self.type)
            
        } else { return false }
    }
    
}
public func ==(lhs: DropDownItem, rhs: DropDownItem) -> Bool {
    return (lhs.id_ == rhs.id_ && lhs.type == rhs.type)
}
