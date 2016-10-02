//
//  LeftMenuItem.swift
//  PlainReader
//
//  Created by guojiubo on 11/28/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

import UIKit
import pop
import CWFoundation

class LeftMenuItem: UIControl {

    var pieView: UIView
    var imageView: UIImageView
    var titleLabel: UILabel

    required init(coder: NSCoder) {
        
        self.pieView = UIView(frame: CGRect.zero)
        self.imageView = UIImageView(frame: CGRect.zero)
        self.titleLabel = UILabel(frame: CGRect.zero)
        
        super.init(coder: coder)!
        
        self.pieView.frame = CGRect(x: 10, y: (self.bounds.height - 28) / 2, width: 28, height: 28)
        self.pieView.layer.cornerRadius = 14
        self.pieView.layer.masksToBounds = true
        self.pieView.backgroundColor = CW_HEXColor(0xc7ccd2)
        self.addSubview(self.pieView)
        
        self.imageView.frame = CGRect(x: 10, y: (self.bounds.height - 28) / 2, width: 28, height: 28)
        self.addSubview(self.imageView)
        
        self.titleLabel.frame = CGRect(x: self.imageView.frame.maxX + 20, y: 0, width: 120, height: self.bounds.height)
        self.titleLabel.font = UIFont.systemFont(ofSize: 19)
        self.titleLabel.textColor = UIColor.white
        self.addSubview(self.titleLabel)
    }

    override var isSelected: Bool {
        didSet {
            isSelected ? self.zoomIn() : self.zoomOut()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.zoomIn()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if self.isSelected {
            return
        }
        
        self.zoomOut()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if self.isSelected {
            return;
        }
        
        self.zoomOut()
    }
    
    func zoomIn() {
        let zoomIn = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        zoomIn?.springBounciness = 20
        zoomIn?.springSpeed = 20
        zoomIn?.dynamicsTension = 1000
        zoomIn?.toValue = NSValue(cgSize: CGSize(width: 1.2, height: 1.2))
        self.pieView.pop_add(zoomIn, forKey: "zoomAnimation")
        
        let layerColor = POPBasicAnimation(propertyNamed: kPOPViewBackgroundColor)
        layerColor?.toValue = CW_HEXColor(0x23beff)
        self.pieView.pop_add(layerColor, forKey: "backgroundColorAnimation")
        
        let textColor = POPBasicAnimation(propertyNamed: kPOPLabelTextColor)
        textColor?.toValue = CW_HEXColor(0x23beff)
        self.titleLabel.pop_add(textColor, forKey: "textColorAnimation")
    }
    
    func zoomOut() {
        let zoomOut = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        zoomOut?.springBounciness = 20
        zoomOut?.springSpeed = 20
        zoomOut?.dynamicsTension = 1000
        zoomOut?.toValue = NSValue(cgSize: CGSize(width: 1, height: 1))
        self.pieView.pop_add(zoomOut, forKey: "zoomAnimation")
        
        let layerColor = POPBasicAnimation(propertyNamed: kPOPViewBackgroundColor)
        layerColor?.toValue = CW_HEXColor(0xc7ccd2)
        self.pieView.pop_add(layerColor, forKey: "backgroundColorAnimation")
        
        let textColor = POPBasicAnimation(propertyNamed: kPOPLabelTextColor)
        textColor?.toValue = UIColor.white
        self.titleLabel.pop_add(textColor, forKey: "textColorAnimation")
    }
}
