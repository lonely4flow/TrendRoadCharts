//
//  UIView+LFRect.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import Foundation
import UIKit
extension UIScreen {
    var lf_x: CGFloat {
        get {
            return self.bounds.origin.x
        }
        set {
//            self.frame.origin.x = newValue
        }
    }
    var lf_y: CGFloat {
        get {
            return self.bounds.origin.y
        }
        set {
//            self.frame.origin.y = newValue
        }
    }
    var lf_width: CGFloat {
        get {
            return self.bounds.size.width
        }
        set {
//            self.frame.size.width = newValue
        }
    }
    var lf_height: CGFloat {
        get {
            return self.bounds.size.height
        }
        set {
//            self.frame.size.height = newValue
        }
    }
    var lf_left: CGFloat {
        get {
            return self.bounds.origin.x
        }
        set {
//            self.frame.origin.x = newValue
        }
    }
    var lf_right: CGFloat {
        get {
            return self.bounds.origin.x+self.bounds.size.width
        }
        set {
//            self.frame.origin.x = newValue-self.frame.size.width
        }
    }
    var lf_top: CGFloat {
        get {
            return self.bounds.origin.y
        }
        set {
//            self.frame.origin.y = newValue
        }
    }
    var lf_bottom: CGFloat {
        get {
            return self.bounds.origin.y+self.bounds.size.height
        }
        set {
//            self.frame.origin.y = newValue-self.frame.size.height
        }
    }
}
extension UIView {
    var lf_x: CGFloat {
        get {
           return self.frame.origin.x
        }
        set {
           self.frame.origin.x = newValue
        }
    }
    var lf_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    var lf_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    var lf_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    var lf_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    var lf_right: CGFloat {
        get {
            return self.frame.origin.x+self.frame.size.width
        }
        set {
            self.frame.origin.x = newValue-self.frame.size.width
        }
    }
    var lf_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    var lf_bottom: CGFloat {
        get {
            return self.frame.origin.y+self.frame.size.height
        }
        set {
            self.frame.origin.y = newValue-self.frame.size.height
        }
    }
}
