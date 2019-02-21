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
    
    init(view: UIView) {
        let container = UIView()
        container.frame = view.frame
        container.backgroundColor = UIColor.black
        container.alpha = 0.7
        
        super.init(frame: view.frame)
        
        container.addSubview(self)
        
        view.addSubview(container)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

}
