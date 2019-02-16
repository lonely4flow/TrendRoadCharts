//
//  UIColor+LFTool.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 31/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    public static func lf_randomColor() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
    public static func lf_rgb(r:Int,g: Int,b:Int,alpha: CGFloat = 1.0) -> UIColor {
        let red: CGFloat = CGFloat( Double(r)/255.0)
        let green: CGFloat = CGFloat( Double(g)/255.0)
        let blue: CGFloat = CGFloat( Double(b)/255.0)
        return UIColor(r: red, g: green, b: blue, alpha: alpha)
    }
    
    func lf_colorImage() -> UIImage? {
        let rect = CGRect(x: 9, y: 9, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return image
    }
}
