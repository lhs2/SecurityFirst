//
//  UIButton+Border.swift
//  SecurityFirst
//
//  Created by de Sousa, Luiz H. on 06/04/2018.
//  Copyright © 2018 de Sousa, Luiz H. All rights reserved.
//

import Foundation
import UIKit


//@IBDesignable
class BorderUIButton: UIButton {
    
    enum ButtonType: Int {
        case borderButton
        case borderlessButton
        case imageButton
        
    }
    
    var type: ButtonType = .borderButton {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var typeAdapter:Int {
        get {
            return self.type.rawValue
        }
        set(index) {
            self.type = ButtonType(rawValue: index) ?? .borderButton
        }
    }

    
    
    // MARK: Overrides
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        switch type {
        case .borderButton:
            self.setTitleColor(#colorLiteral(red: 0.06666666667, green: 0.6156862745, blue: 0.6431372549, alpha: 1), for: .normal)
            self.setTitleColor(#colorLiteral(red: 0.06666666667, green: 0.6156862745, blue: 0.6431372549, alpha: 0.748184419), for: .highlighted)
            self.fillColor = .clear
            self.layer.cornerRadius = 10.0
            self.layer.borderWidth = 3.0
            self.layer.borderColor = self.isEnabled ? #colorLiteral(red: 0.06666666667, green: 0.6156862745, blue: 0.6431372549, alpha: 1) : #colorLiteral(red: 0.06666666667, green: 0.6156862745, blue: 0.6431372549, alpha: 0.3032845511)
            self.layer.masksToBounds = true
            
        
        case .borderlessButton:
            self.setTitleColor(#colorLiteral(red: 0.06666666667, green: 0.6156862745, blue: 0.6431372549, alpha: 1), for: .normal)
            self.setTitleColor(#colorLiteral(red: 0.06666666667, green: 0.6156862745, blue: 0.6431372549, alpha: 0.748184419), for: .highlighted)
            self.fillColor = .clear
            self.layer.borderWidth = 0.0
            self.layer.masksToBounds = true
            
        case .imageButton:
            self.fillColor = .clear
            self.layer.masksToBounds = true
            
             }
        
        layoutRoundRectLayer()
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        
    }
    
    // MARK: Private
    
    private var roundRectLayer: CAShapeLayer?
    
    private var roundRectCornerRadius: CGFloat = 4
    private var roundRectColor: UIColor = #colorLiteral(red: 0.06666666667, green: 0.6156862745, blue: 0.6431372549, alpha: 1)
    private var fillColor: UIColor = .white
    
    
    private func layoutRoundRectLayer() {
        if let existingLayer = roundRectLayer {
            existingLayer.removeFromSuperlayer()
        }
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: roundRectCornerRadius).cgPath
        
        switch type {
        case .borderButton:
            shapeLayer.fillColor = fillColor.cgColor
            shapeLayer.strokeColor = roundRectColor.cgColor
            shapeLayer.lineWidth = 2.0
            
        case .borderlessButton:
            shapeLayer.fillColor = fillColor.cgColor
            shapeLayer.strokeColor = roundRectColor.cgColor
            shapeLayer.lineWidth = 0.0
            
        case .imageButton:
            print("do not")
            
        }
        
        self.layer.insertSublayer(shapeLayer, at: 0)
        self.roundRectLayer = shapeLayer
    }
    
    init(view: UIView, text: String = "", hasNav: Bool = false) {
        let auxHeight = hasNav ? view.bounds.height - 20 - 50 - 64 : view.bounds.height - 20 - 50
        let frame = CGRect(x: 20, y: auxHeight, width: view.bounds.width - 40, height: view.bounds.height/10)
        super.init(frame: frame)
        self.setTitle(text, for: .normal)
        
        view.addSubview(self)
        view.bringSubview(toFront: self)
    }
    
    init(view: UIView, image: String, hasNav: Bool = false) {
        let auxHeight = hasNav ? view.bounds.height - 20 - 50 - 64 : view.bounds.height - 20 - 50
        let frame = CGRect(x: 20, y: auxHeight, width: view.bounds.width - 40, height: 50)
        super.init(frame: frame)
        self.imageView?.image = UIImage(named: image)
        
        view.addSubview(self)
        view.bringSubview(toFront: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
