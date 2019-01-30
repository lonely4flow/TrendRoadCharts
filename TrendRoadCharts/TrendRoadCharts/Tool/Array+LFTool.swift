//
//  Array+LFTool.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFow on 30/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import Foundation
extension Array {
    // 构建数字的数组
    public static func lf_fillNum(from: Int,to: Int,zeroCount: Int = 1) -> [String] {
        var array: [String] = []
        let format = String(format: "%%0%ldld", zeroCount)
        for num in from...to {
            let txt = String(format: format, num)
            array.append(txt)
        }
        return array
    }
    
    // 数组里是否包含查找文本，默认忽略无意义的0
    public func lf_isContain(txt: String,isAgoreZero:Bool = true) -> Bool {
        
        var originArray:[String] = self as! [String]
        var findTxt = txt
        if isAgoreZero {
            // 忽略无意义的0
            originArray = originArray.map({ (obj: String) -> String in
                var noZeroTxt = obj
                while noZeroTxt.hasPrefix("0") {
                    noZeroTxt = String(noZeroTxt.suffix(noZeroTxt.count-1))
                }
                return noZeroTxt
            })
            
            while findTxt.hasPrefix("0") {
                findTxt = String(findTxt.suffix(findTxt.count-1))
            }
        }
        return originArray.contains(findTxt)
    }
    
    // 包含个数
    public func lf_findCount(txt: String,isAgoreZero:Bool = true) -> Int {
        var originArray:[String] = self as! [String]
        var findTxt = txt
        if isAgoreZero {
            // 忽略无意义的0
            originArray = originArray.map({ (obj: String) -> String in
                var noZeroTxt = obj
                while noZeroTxt.hasPrefix("0") {
                    noZeroTxt = String(noZeroTxt.suffix(noZeroTxt.count-1))
                }
                return noZeroTxt
            })
            
            while findTxt.hasPrefix("0") {
                findTxt = String(findTxt.suffix(findTxt.count-1))
            }
        }
        var findCount = 0
        for numTxt in originArray {
            if numTxt == findTxt {
                findCount += 1
            }
        }
        return findCount
    }
    
    // 包含内容
    public func lf_findTxt(txt: String,isAgoreZero:Bool = true) -> String? {
        var originArray:[String] = self as! [String]
        var findTxt = txt
        if isAgoreZero {
            // 忽略无意义的0
            originArray = originArray.map({ (obj: String) -> String in
                var noZeroTxt = obj
                while noZeroTxt.hasPrefix("0") {
                    noZeroTxt = String(noZeroTxt.suffix(noZeroTxt.count-1))
                }
                return noZeroTxt
            })
            
            while findTxt.hasPrefix("0") {
                findTxt = String(findTxt.suffix(findTxt.count-1))
            }
        }
        for index in 0..<originArray.count {
            let numTxt = originArray[index]
            if numTxt == findTxt {
                return (self[index] as! String)
            }
        }
        return nil
    }
    
    
}
