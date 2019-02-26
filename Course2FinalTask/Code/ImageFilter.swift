//
//  ImageFilter.swift
//  Course2FinalTask
//
//  Created by Vladislav on 26/02/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import UIKit

public class ImageFilter {
    
    let context = CIContext()
    
    public init() {}
    
    func applyFilter(name: String, params: [String: Any]) -> UIImage? {
        
        guard let filter = CIFilter(name: name, withInputParameters: params),
            let outputImage = filter.outputImage,
            let cgiimage = context.createCGImage(outputImage, from: outputImage.extent) else {
                return nil
        }
        
        return UIImage(cgImage: cgiimage)
    }
    
}
