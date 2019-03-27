//
//  Spinner.swift
//
//  Created by Michał Majchrzycki on 28.03.2018.
//  Copyright © 2018 Prograils.com. All rights reserved.
//  Check whole tutorial at: https://prograils.com/posts/reusable-activity-indicator-with-swift

import UIKit

// Взял этот код из туториала, ссылка на который выше.
// Есть своя реализация в классе CustomActivityInidicator, но решил в итоге использовать эту.

open class Spinner {
    
    internal static var spinner: UIActivityIndicatorView?
    static var style: UIActivityIndicatorViewStyle = .white
    static var baseBackColor = UIColor.black.withAlphaComponent(0.7)
    static var baseColor = UIColor.white
    
    static func start(style: UIActivityIndicatorViewStyle = style, backColor: UIColor = baseBackColor, baseColor: UIColor = baseColor) {
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        if spinner == nil, let window = UIApplication.shared.keyWindow {
            let frame = UIScreen.main.bounds
            spinner = UIActivityIndicatorView(frame: frame)
            spinner!.backgroundColor = backColor
            spinner!.activityIndicatorViewStyle = style
            spinner?.color = baseColor
            window.addSubview(spinner!)
            spinner!.startAnimating()
        }
    }
    
    static func stop() {
        if spinner != nil {
            spinner!.stopAnimating()
            spinner!.removeFromSuperview()
            spinner = nil
        }
    }
    
    @objc static func update() {
        if spinner != nil {
            stop()
            start()
        }
    }
}
