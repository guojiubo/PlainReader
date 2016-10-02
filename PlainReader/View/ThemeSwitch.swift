//
//  ThemeSwitch.swift
//  PlainReader
//
//  Created by guo on 11/29/14.
//  Copyright (c) 2014 guojiubo. All rights reserved.
//

import UIKit
import CWFoundation

class ThemeSwitch: UIControl {
    
    var normalLabel = UILabel(frame: CGRect.zero)
    var selectedLabel = UILabel(frame: CGRect.zero)
    var imageView = UIImageView(image: UIImage(named: "ThemeNight"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        
        self.setup()
    }
    
    func setup() {
        
        let border = UIImageView(image: UIImage(named: "ThemeSwitchBorder"))
        border.center.y = self.bounds.height / 2
        self.addSubview(border)
        
        self.normalLabel.frame = CGRect(x: 10, y: (self.bounds.height - border.bounds.height) / 2, width: border.bounds.width - 20, height: border.bounds.height)
        self.normalLabel.font = UIFont.systemFont(ofSize: 12)
        self.normalLabel.textColor = UIColor.white
        self.normalLabel.text = "夜间"
        self.normalLabel.textAlignment = .right
        self.addSubview(normalLabel)
        
        self.selectedLabel.frame = CGRect(x: 10, y: (self.bounds.height - border.bounds.height) / 2, width: border.bounds.width - 20, height: border.bounds.height)
        self.selectedLabel.font = UIFont.systemFont(ofSize: 12)
        self.selectedLabel.textColor = CW_HEXColor(0x23beff)
        self.selectedLabel.text = "白天"
        self.selectedLabel.alpha = 0
        self.addSubview(selectedLabel)
        
        self.imageView.frame = CGRect(x: 5, y: (self.bounds.height - self.imageView.bounds.height) / 2, width: self.imageView.bounds.width, height: self.imageView.bounds.height)
        self .addSubview(self.imageView)
        
        self.addTarget(self, action: #selector(ThemeSwitch.handleTouchDown(_:)), for: .touchDown)
        
    }
    
    func handleTouchDown(_ sender: UIControl) {
        self.isSelected = !self.isSelected
        
        self.sendActions(for: .valueChanged)
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.normalLabel.alpha = self.isSelected ? 0 : 1
                self.selectedLabel.alpha = self.isSelected ? 1 : 0
                
                var frame = self.imageView.frame
                frame.origin.x = self.isSelected ? ( self.bounds.width - self.imageView.bounds.width - 5) : 5
                self.imageView.frame = frame
            })
            
            UIView.transition(with: self.imageView, duration: 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
                self.imageView.image = self.isSelected ? UIImage(named: "ThemeDay") : UIImage(named: "ThemeNight")
            }, completion: nil)
        }
    }

}
