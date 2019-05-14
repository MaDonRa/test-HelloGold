//
//  SetupFont.swift
//  vHealth
//
//  Created by Sakkaphong Luaengvilai on 12/5/2559 BE.
//  Copyright © 2559 MaDonRa. All rights reserved.
//

import UIKit

enum FontType {
    case SFProText_Bold , SFProText_Regular , SFProText_Semibold
    
    var Name : String {
        switch self {
        case .SFProText_Bold:
            return "SFProText-Bold"
        case .SFProText_Regular:
            return "SFProText-Regular"
        case .SFProText_Semibold:
            return "SFProText-Semibold"
        }
    }
}


extension UILabel {
    
    open override func awakeFromNib() {
        self.SetupFont()
    }
    
    func SetupFont() {
        guard let FontName = self.font?.fontName else { return }
        self.font = UIFont.mainFont(name: FontName, size: self.font.pointSize)
    }
    
    func ClearAttributes() {
        guard let textString = self.text else { return }
        self.attributedText = NSAttributedString(string: textString, attributes:nil)
    }
    
    func UnderLine() {
        guard let textString = self.text else { return }
        self.attributedText = NSAttributedString(string: textString, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    func SetTitleAndDetail(Title : String , TitleFont : FontType = FontType.SFProText_Bold , TitleColor : UIColor? = nil , Detail : String , DetailFont : FontType = FontType.SFProText_Regular , DetailColor : UIColor? = nil , FontSize : CGFloat) {
        
        let attributedString1 = NSMutableAttributedString(string: Title, attributes:[NSAttributedString.Key.font : UIFont.mainFont(name: TitleFont.Name, size: FontSize), NSAttributedString.Key.foregroundColor: (TitleColor ?? self.textColor) as UIColor])
        let attributedString2 = NSMutableAttributedString(string: " " + Detail, attributes:[NSAttributedString.Key.font : UIFont.mainFont(name: DetailFont.Name, size: FontSize), NSAttributedString.Key.foregroundColor: (DetailColor ?? self.textColor) as UIColor])
        attributedString1.append(attributedString2)
        
        attributedText = attributedString1
    }
}

extension UIButton {
    
    open override func awakeFromNib() {
        self.SetupFont()
    }
    
    func SetupFont() {
        guard let ButtonFont = self.titleLabel else { return }
        self.titleLabel?.font = UIFont.mainFont(name: ButtonFont.font.fontName, size: ButtonFont.font.pointSize)
    }
    
    func UnderLine() {
        guard let textString = self.titleLabel?.text else { return }
        self.titleLabel?.attributedText = NSAttributedString(string: textString, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    func ClearAttributes() {
        guard let textString = self.titleLabel?.text else { return }
        self.titleLabel?.attributedText = NSAttributedString(string: textString, attributes: nil)
    }
    
    func SetTitleAndDetail(Title : String , TitleFont : FontType = FontType.SFProText_Bold , TitleColor : UIColor? = nil , Detail : String , DetailFont : FontType = FontType.SFProText_Regular , DetailColor : UIColor? = nil , FontSize : CGFloat) {
        
        let attributedString1 = NSMutableAttributedString(string: Title, attributes:[NSAttributedString.Key.font : UIFont.mainFont(name: TitleFont.Name, size: FontSize), NSAttributedString.Key.foregroundColor: (TitleColor ?? (self.titleLabel?.textColor ?? UIColor.black)) as UIColor])
        let attributedString2 = NSMutableAttributedString(string: " " + Detail, attributes:[NSAttributedString.Key.font : UIFont.mainFont(name: DetailFont.Name, size: FontSize), NSAttributedString.Key.foregroundColor: (DetailColor ?? self.titleLabel?.textColor ?? UIColor.black) as UIColor])
        attributedString1.append(attributedString2)
        
        self.setAttributedTitle(attributedString1, for: .normal)
    }
}

extension UITextField {
    
    open override func awakeFromNib() {
        self.SetupFont()
        //self.AddDoneButtonOnKeyboard()
    }
    
    func SetupFont() {
        guard let TextFieldFont = self.font else { return }
        self.font = UIFont.mainFont(name: TextFieldFont.fontName, size: TextFieldFont.pointSize)
    }
    
    func ClearAttributes() {
        guard let textString = self.text else { return }
        self.attributedText = NSAttributedString(string: textString, attributes:nil)
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes:[NSAttributedString.Key.foregroundColor: newValue ?? UIColor.white])
        }
    }
    
//    func AddDoneButtonOnKeyboard() {
//        let keyboardToolbar = UIToolbar()
//        keyboardToolbar.sizeToFit()
//
//        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
//                                            target: nil, action: nil)
//        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
//                                            target: self, action: #selector(UIView.endEditing(_:)))
//        keyboardToolbar.items = [flexBarButton, doneBarButton]
//        self.inputAccessoryView = keyboardToolbar
//    }
}

extension UITextView {
    
    open override func awakeFromNib() {
        self.SetupFont()
        //self.AddDoneButtonOnKeyboard()
    }
    
    func SetupFont() {
        guard let TextViewFont = self.font , let textString = self.text else { return }
        self.font = UIFont.mainFont(name: TextViewFont.fontName, size: TextViewFont.pointSize)
        self.attributedText = NSAttributedString(string: textString, attributes:[NSAttributedString.Key.foregroundColor:self.textColor ?? UIColor.white])
    }
    
//    func AddDoneButtonOnKeyboard() {
//        let keyboardToolbar = UIToolbar()
//        keyboardToolbar.sizeToFit()
//
//        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
//                                            target: nil, action: nil)
//        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
//                                            target: self, action: #selector(UIView.endEditing(_:)))
//        keyboardToolbar.items = [flexBarButton, doneBarButton]
//        self.inputAccessoryView = keyboardToolbar
//    }
}

extension UISegmentedControl {
    
    open override func awakeFromNib() {
        self.SetupFont()
    }
    
    func SetupFont() {
        self.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: ScreenSize.SCREEN_ASPECT_AutoLayout * 16) ], for: .normal)
    }
}

extension UINavigationController {
    
    open override func awakeFromNib() {
        //SetupFont()
    }
    
    func SetupFont(TextColor : UIColor = UIColor.white) {
        guard let FontSize = UIFont(name: FontType.SFProText_Regular.Name, size: (ScreenSize.SCREEN_WIDTH_AutoLayout * 18) <= 18 ? ScreenSize.SCREEN_WIDTH_AutoLayout * 18 : 18) else { return }
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontSize , NSAttributedString.Key.foregroundColor : TextColor]
    }
}

extension UITabBarItem {
    
    open override func awakeFromNib() {
        //SetupFont()
    }
    
    func SetupFont() {
        guard let FontSize = UIFont(name: FontType.SFProText_Regular.Name, size: 10) else { return }
        self.setTitleTextAttributes([NSAttributedString.Key.font: FontSize ], for: UIControl.State.normal)
        self.setTitleTextAttributes([NSAttributedString.Key.font: FontSize ], for: UIControl.State.selected)
    }
}

extension UIFont {
    
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: (ScreenSize.SCREEN_ASPECT_AutoLayout) * size) ?? UIFont.systemFont(ofSize: (ScreenSize.SCREEN_ASPECT_AutoLayout) * size)
    }
    
    static func mainFont(name : String , size: CGFloat) -> UIFont {
        return customFont(name: name, size: size)
    }
}

