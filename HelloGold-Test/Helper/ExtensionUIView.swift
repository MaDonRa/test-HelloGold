//
//  ExtensionUIView.swift
//  Wala_Office
//
//  Created by Sakkaphong on 2/15/18.
//  Copyright © 2018 Sakkaphong. All rights reserved.
//

import UIKit
import AudioToolbox

extension UIView {
    
    func Circle() {
        OperationQueue.main.addOperation { [weak self] in
            guard let self = self else { return }
            self.layer.masksToBounds = true
            self.layer.cornerRadius = self.frame.size.height / 2.0
        }
    }
    
    func Shadow(Radius:CGFloat = 3 , Color:UIColor = UIColor.black , Height:CGFloat = 3 , Width: CGFloat = 1 , Opacity:Float = 0.5) {
        self.layer.shadowColor = Color.cgColor
        self.layer.shadowOpacity = Opacity
        self.layer.shadowOffset = CGSize(width: Width, height: Height)
        self.layer.shadowRadius = Radius
        self.layer.masksToBounds = false
    }
    
    func HideShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 0
        self.layer.masksToBounds = false
    }
    
    func Border(Color:UIColor , Border:CGFloat , Alpha:CGFloat = 1.0) {
        self.layer.borderWidth = Border
        self.layer.borderColor = Color.withAlphaComponent(Alpha).cgColor
        guard Color == UIColor.red else { return }
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    func DashedLineBorder(Color:UIColor , Alpha : CGFloat = 1.0 , Padding : NSNumber = 4 , Size : CGSize? = nil) {
        let DashedLine = CAShapeLayer()
        DashedLine.strokeColor = Color.withAlphaComponent(Alpha).cgColor
        DashedLine.lineDashPattern = [Padding, Padding]
        if let Size = Size {
            DashedLine.frame = CGRect(x: 0, y: 0, width: Size.width, height: Size.height)
        } else {
            DashedLine.frame = self.bounds
        }
        DashedLine.fillColor = nil
        DashedLine.path = UIBezierPath(rect: DashedLine.frame).cgPath
        self.layer.addSublayer(DashedLine)
    }
    
    internal enum BorderPosition {
        case Top , Bottom , Left , Right
    }
  
    func BorderCustom(Location : BorderPosition , Color:UIColor , UISize : CGSize , Border: CGFloat) {
        
        var lineView = UIView()
        
        switch Location {
        case .Top :
            lineView = UIView(frame: CGRect(x: 0, y: 0, width: UISize.width, height: Border))
        case .Bottom :
            lineView = UIView(frame: CGRect(x: 0, y: UISize.height-Border, width: UISize.width, height: Border))
        case .Left :
            lineView = UIView(frame: CGRect(x: 0, y: 0, width: Border, height: UISize.height))
        case .Right :
            lineView = UIView(frame: CGRect(x: UISize.width-Border, y: 0, width:Border, height: UISize.height))
        }
        
        lineView.backgroundColor=Color
        self.addSubview(lineView)
    }
}
