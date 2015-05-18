//
//  ThemeSwitch.swift
//  PlainReader
//
//  Created by guo on 11/29/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

import UIKit

class ThemeSwitch: UIControl {
    
    var normalLabel = UILabel(frame: CGRectZero)
    var selectedLabel = UILabel(frame: CGRectZero)
    var imageView = UIImageView(image: UIImage(named: "ThemeNight"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setup()
    }
    
    func setup() {
        
        let border = UIImageView(image: UIImage(named: "ThemeSwitchBorder"))
        border.center.y = self.bounds.height / 2
        self.addSubview(border)
        
        self.normalLabel.frame = CGRect(x: 10, y: (self.bounds.height - border.bounds.height) / 2, width: border.bounds.width - 20, height: border.bounds.height)
        self.normalLabel.font = UIFont.systemFontOfSize(12)
        self.normalLabel.textColor = UIColor.whiteColor()
        self.normalLabel.text = "夜间"
        self.normalLabel.textAlignment = .Right
        self.addSubview(normalLabel)
        
        self.selectedLabel.frame = CGRect(x: 10, y: (self.bounds.height - border.bounds.height) / 2, width: border.bounds.width - 20, height: border.bounds.height)
        self.selectedLabel.font = UIFont.systemFontOfSize(12)
        self.selectedLabel.textColor = CW_HEXColor(0x23beff)
        self.selectedLabel.text = "白天"
        self.selectedLabel.alpha = 0
        self.addSubview(selectedLabel)
        
        self.imageView.frame = CGRect(x: 5, y: (CGRectGetHeight(self.bounds) - CGRectGetHeight(self.imageView.bounds)) / 2, width: CGRectGetWidth(self.imageView.bounds), height: CGRectGetHeight(self.imageView.bounds))
        self .addSubview(self.imageView)
        
        self.addTarget(self, action: "handleTouchDown:", forControlEvents: .TouchDown)
        
    }
    
    func handleTouchDown(sender: UIControl) {
        self.selected = !self.selected
        
        self.sendActionsForControlEvents(.ValueChanged)
    }
    
    override var selected: Bool {
        didSet {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.normalLabel.alpha = self.selected ? 0 : 1
                self.selectedLabel.alpha = self.selected ? 1 : 0
                
                var frame = self.imageView.frame
                frame.origin.x = self.selected ? ( self.bounds.width - self.imageView.bounds.width - 5) : 5
                self.imageView.frame = frame
            })
            
            UIView.transitionWithView(self.imageView, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
                self.imageView.image = self.selected ? UIImage(named: "ThemeDay") : UIImage(named: "ThemeNight")
            }, completion: nil)
        }
    }

}
