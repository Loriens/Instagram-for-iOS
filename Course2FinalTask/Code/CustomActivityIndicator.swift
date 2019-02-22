//
//  CustomActivityIndicator.swift
//  Course2FinalTask
//
//  Created by Vladislav on 21/02/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

class CustomActivityIndicator: UIActivityIndicatorView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var wrap: UIView?
    
    init(view: UIView) {
        let container = UIView()
        container.frame = view.frame
        container.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        super.init(frame: view.frame)
        self.center = view.center
        self.isHidden = true
        self.hidesWhenStopped = true
        
        container.isHidden = true
        container.addSubview(self)
        wrap = container
        
        view.addSubview(wrap!)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func startAnimating() {
        super.startAnimating()
        
        if let container = wrap {
            container.isHidden = false
//            self.isHidden = false
        }
    }
    
    override func stopAnimating() {
        if let container = wrap {
            container.isHidden = true
//            self.isHidden = true
        }
        
        super.stopAnimating()
    }

}
