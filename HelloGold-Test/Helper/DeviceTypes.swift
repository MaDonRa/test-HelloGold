//
//  DeviceTypes.swift
//  vHealth
//
//  Created by Sakkaphong Luaengvilai on 12/5/2559 BE.
//  Copyright © 2559 MaDonRa. All rights reserved.
//

import UIKit

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone
    case pad
}

public struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT_Without_Safe_Area   = UIScreen.main.bounds.size.height
    static var SCREEN_HEIGHT        : CGFloat {
        get {
            if #available(iOS 11.0, *) {
                return ScreenSize.SCREEN_HEIGHT_Without_Safe_Area - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) - (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
            } else {
                return ScreenSize.SCREEN_HEIGHT_Without_Safe_Area
            }
        }
    }
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT_Without_Safe_Area)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT_Without_Safe_Area)
    static var SCREEN_HEIGHT_AutoLayout = ScreenSize.SCREEN_HEIGHT / 667
    static let SCREEN_WIDTH_AutoLayout    = ScreenSize.SCREEN_WIDTH / 375
    static let SCREEN_ASPECT_AutoLayout    = (DeviceType.IS_IPAD ? ScreenSize.SCREEN_HEIGHT_AutoLayout/2 : (DeviceType.IS_IPHONE_5 ? ScreenSize.SCREEN_HEIGHT / 568 : ScreenSize.SCREEN_HEIGHT_AutoLayout)) * (DeviceType.IS_IPHONE_5 ? ScreenSize.SCREEN_WIDTH / 320 : ScreenSize.SCREEN_WIDTH_AutoLayout)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH >= 1024.0
}

internal extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
