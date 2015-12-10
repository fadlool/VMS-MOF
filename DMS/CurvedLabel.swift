//
//  CurvedLabel.swift
//  CRS
//
//  Created by Mohamed Fadl on 6/2/15.
//  Copyright (c) 2015 Compulink. All rights reserved.
//

import Foundation
import UIKit

class CurvedLabel : UILabel
{
    var padding : UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func drawTextInRect(rect: CGRect) {
        super.layer.borderColor = UIColor.lightGrayColor().CGColor
        super.layer.masksToBounds = true
        super.layer.borderWidth = 0.5
        super.layer.cornerRadius = 5.0
        super.textColor = UIColor.lightGrayColor()
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, padding))
        
        self.userInteractionEnabled = true
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize
    {
        
        var adjSize = super.sizeThatFits(size)
        adjSize.width += padding.left + padding.right
        adjSize.height += padding.top + padding.bottom
        
        return adjSize
    }
}