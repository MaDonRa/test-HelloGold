//
//  LoadingAnimation.swift
//  Box24
//
//  Created by Sakkaphong Luaengvilai on 31/10/2561 BE.
//  Copyright © 2561 MaDonRa. All rights reserved.
//

import UIKit

class LoadingAnimationV: UIViewController {

    @IBOutlet weak var IconImageView: UIImageView!
    
    internal func SetupLayout() {
        IconImageView.layer.masksToBounds = true
        IconImageView.layer.cornerRadius = (ScreenSize.SCREEN_HEIGHT / 10) / 2.0
    }
}
