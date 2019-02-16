//
//  LFDrawTool.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFDrawTool: NSObject {
    // 画线
     static func lf_drawLine(startPoint:CGPoint,endPoint:CGPoint, lineColor:UIColor, lineWith:CGFloat, context:CGContext?) -> Void
    {
        context?.setLineCap(.round)
        context?.setLineWidth(lineWith)
        context?.setAllowsAntialiasing(true)
        context?.setStrokeColor(lineColor.cgColor)
        context?.beginPath()
        context?.move(to: startPoint)
        context?.addLine(to: endPoint)
        context?.strokePath()
    }
    // 画圆
     static func lf_drawCircle(rect:CGRect,bgColor: UIColor,context:CGContext?,lineWidth:CGFloat=1,isHellow:Bool=false) -> Void
    {
        context?.setFillColor(bgColor.cgColor)
        context?.addEllipse(in: rect)
        if isHellow {
            // 画空心圆
            context?.setLineWidth(lineWidth)
            context?.drawPath(using: .stroke)
        }else{
            // 画实心圆
            context?.drawPath(using: .fill)
        }
    }
    
    // 画文字
    static func lf_drawTxt(txt: String,font: UIFont,color: UIColor,rect:CGRect,context:CGContext?) -> Void
    {
        let txtSize = txt.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: rect.height),options: .usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font:font],context: nil)
        
        let textRect = CGRect(x: (rect.width-txtSize.width)/2, y: (rect.height-txtSize.height)/2, width: txtSize.width, height: txtSize.height)
        txt.draw(in: textRect, withAttributes: [NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor:color])
    }
    
    static func lf_txtWidth(txt: String,font: UIFont,height:CGFloat) -> CGFloat
    {
        let txtSize = txt.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height),options: .usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font:font],context: nil)
        return txtSize.width
    }
    static func lf_txtHeight(txt: String,font: UIFont,width:CGFloat) -> CGFloat
    {
        let txtSize = txt.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)),options: .usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font:font],context: nil)
        return txtSize.width
    }
}
