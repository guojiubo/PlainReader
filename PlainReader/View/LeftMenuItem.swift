//
//  LeftMenuItem.swift
//  PlainReader
//
//  Created by guojiubo on 11/28/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

import UIKit

class LeftMenuItem: UIControl {

    var pieView: UIView
    var imageView: UIImageView
    var titleLabel: UILabel

    required init(coder: NSCoder) {
        
        self.pieView = UIView(frame: CGRectZero)
        self.imageView = UIImageView(frame: CGRectZero)
        self.titleLabel = UILabel(frame: CGRectZero)
        
        super.init(coder: coder)
        
        self.pieView.frame = CGRectMake(10, (CGRectGetHeight(self.bounds) - 28) / 2, 28, 28)
        self.pieView.layer.cornerRadius = 14
        self.pieView.layer.masksToBounds = true
        self.pieView.backgroundColor = CW_HEXColor(0xc7ccd2)
        self.addSubview(self.pieView)
        
        self.imageView.frame = CGRectMake(10, (CGRectGetHeight(self.bounds) - 28) / 2, 28, 28)
        self.addSubview(self.imageView)
        
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) + 20, 0, 120, CGRectGetHeight(self.bounds))
        self.titleLabel.font = UIFont.systemFontOfSize(19)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.titleLabel)
    }

    override var selected: Bool {
        didSet {
            selected ? self.zoomIn() : self.zoomOut()
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        self.zoomIn()
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
        
        if self.selected {
            return
        }
        
        self.zoomOut()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)
        
        if self.selected {
            return;
        }
        
        self.zoomOut()
    }
    
    func zoomIn() {
        let zoomIn = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        zoomIn.springBounciness = 20
        zoomIn.springSpeed = 20
        zoomIn.dynamicsTension = 1000
        zoomIn.toValue = NSValue(CGSize: CGSizeMake(1.2, 1.2))
        self.pieView.pop_addAnimation(zoomIn, forKey: "zoomAnimation")
        
        let layerColor = POPBasicAnimation(propertyNamed: kPOPViewBackgroundColor)
        layerColor.toValue = CW_HEXColor(0x23beff)
        self.pieView.pop_addAnimation(layerColor, forKey: "backgroundColorAnimation")
        
        let textColor = POPBasicAnimation(propertyNamed: kPOPLabelTextColor)
        textColor.toValue = CW_HEXColor(0x23beff)
        self.titleLabel.pop_addAnimation(textColor, forKey: "textColorAnimation")
    }
    
    func zoomOut() {
        let zoomOut = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        zoomOut.springBounciness = 20
        zoomOut.springSpeed = 20
        zoomOut.dynamicsTension = 1000
        zoomOut.toValue = NSValue(CGSize: CGSizeMake(1, 1))
        self.pieView.pop_addAnimation(zoomOut, forKey: "zoomAnimation")
        
        let layerColor = POPBasicAnimation(propertyNamed: kPOPViewBackgroundColor)
        layerColor.toValue = CW_HEXColor(0xc7ccd2)
        self.pieView.pop_addAnimation(layerColor, forKey: "backgroundColorAnimation")
        
        let textColor = POPBasicAnimation(propertyNamed: kPOPLabelTextColor)
        textColor.toValue = UIColor.whiteColor()
        self.titleLabel.pop_addAnimation(textColor, forKey: "textColorAnimation")
    }
}
