//
//  LoadingAnimationC.swift
//  Box24
//
//  Created by Sakkaphong Luaengvilai on 31/10/2561 BE.
//  Copyright © 2561 MaDonRa. All rights reserved.
//

import UIKit

extension LoadingAnimationV {
    
    override func viewDidLoad() {
        SetupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StartAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        RegisterLocalNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        StopAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    internal func RegisterLocalNotification() {
        NotificationCenter.default.removeObserver(self)

        NotificationCenter.default.addObserver(self, selector: #selector(self.StartAnimation), name: UIApplication.didBecomeActiveNotification , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.StopAnimation), name: UIApplication.willResignActiveNotification , object: nil)
    }
    
    @objc private func StartAnimation() {
        DispatchQueue.main.async {
            OperationQueue.main.addOperation { [weak self] in
                guard let self = self else { return }
                let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
                rotationAnimation.toValue = Double.pi * 2
                rotationAnimation.duration = 1.0
                rotationAnimation.repeatCount = Float.infinity
                rotationAnimation.isCumulative = true
                self.IconImageView.layer.add(rotationAnimation, forKey: nil)
            }
        }
    }
    
    @objc private func StopAnimation() {
        self.IconImageView.layer.removeAllAnimations()
    }
}
