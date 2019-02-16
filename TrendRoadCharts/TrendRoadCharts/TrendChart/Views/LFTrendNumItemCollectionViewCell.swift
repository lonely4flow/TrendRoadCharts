//
//  LFTrendNumItemCollectionViewCell.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 31/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit
public enum LFTrendNumItemCollectionViewCellAwardBgStyle {
    
    
    case none(txtColor: UIColor) // 无背景颜色
    case circle(bgColor:UIColor,txtColor:UIColor) // 圆圈背景（背景颜色、文本颜色）
    case radiusRound(bgColor:UIColor,txtColor:UIColor,radius:CGFloat) // 有圆角的的矩形（背景颜色、文本颜色、圆角）
    case round(bgColor:UIColor,txtColor:UIColor) // 无圆角的矩形（背景颜色、文本颜色）
}
class LFTrendNumItemCollectionViewCell: UICollectionViewCell {
    // 中奖背景样式
    var awardStyle:LFTrendNumItemCollectionViewCellAwardBgStyle = .none(txtColor: UIColor.black)
    // 要展示的文字
    var showTxt:String?
    
    // 只有这个大于0时才展示
    var awardCount:Int = 0
    // awardCount大于0时右上角小圆圈的颜色
    var smallCircleBgColor: UIColor?
    // awardCount大于0时右上角小圆圈的文字颜色
    var smallCircleTxtColor: UIColor?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 获取上下文/创建画布
        let context = UIGraphicsGetCurrentContext()
        // 设置填充色
        //CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
        // 圆形直径
       // CGFloat w = MIN(self.cellItemSzie.width, self.cellItemSzie.height) - 4;
        // 园点坐标
        //CGPoint center = CGPointMake(rect.origin.x + rect.size.width / 2.0,
         //                            rect.origin.y + rect.size.height / 2.0);
        switch self.awardStyle {
        case let .none(txtColor):
            self.drawShowTxt(txtColor: txtColor,rect:rect)
        case let .circle(bgColor,txtColor):
            self.drawCircleBg(context: context!, rect: rect, bgColor: bgColor)
            self.drawShowTxt(txtColor: txtColor,rect:rect)
            self.drawAwardCountCircle(context: context!, rect: rect)
        case let .radiusRound(bgColor,txtColor,radius):
            self.drawRoundBg(context: context!, rect: rect, bgColor: bgColor, radius: radius)
            self.drawShowTxt(txtColor: txtColor,rect:rect)
            self.drawAwardCountCircle(context: context!, rect: rect)
        case let .round(bgColor,txtColor):
            self.drawRoundBg(context: context!, rect: rect, bgColor: bgColor, radius: 0)
            self.drawShowTxt(txtColor: txtColor,rect:rect)
            self.drawAwardCountCircle(context: context!, rect: rect)
        }
        
        // 画边框左侧+顶侧
        context?.setLineCap(.round)
        context?.setLineWidth(1)
        context?.setAllowsAntialiasing(true)
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.beginPath()
        context?.move(to: CGPoint(x: 0, y: rect.height))
        context?.addLine(to: CGPoint.zero)
        context?.addLine(to: CGPoint(x: rect.width, y: 0))
        context?.strokePath()
    }
    func drawCircleBg(context:CGContext,rect:CGRect,bgColor:UIColor) -> Void {
        // 园点坐标
        let center:CGPoint = CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height / 2)
        // 圆形半径
        let radius: CGFloat = (min(rect.width, rect.height) - 4)/2
        // 设置圆形
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        bgColor.set()
        context.drawPath(using: .fill)
    }
    func drawRoundBg(context:CGContext,rect:CGRect,bgColor:UIColor,radius:CGFloat) -> Void {
        let width: CGFloat = rect.width-6
        let height: CGFloat = rect.height-6
        let x: CGFloat = (rect.width - width) / 2
        let y: CGFloat = (rect.height - height) / 2-radius/2
        // 左上角的点
        let topLeftPoint: CGPoint = CGPoint(x: x, y: y+radius)
        // 右上角的点
        let topRightPoint: CGPoint = CGPoint(x: x+width, y: y)
        // 左下角的点
        let bottomLeftPoint: CGPoint = CGPoint(x: x, y: y+height)
        // 右下角的点
        let bottomRightPoint: CGPoint = CGPoint(x: x+width, y: y+height)
        
        let point1 = CGPoint(x: topLeftPoint.x, y: topLeftPoint.y+radius)
        let point2 = CGPoint(x: topLeftPoint.x+radius, y: topLeftPoint.y)
        context.move(to: point1)
        context.addArc(tangent1End: topLeftPoint, tangent2End: point2, radius: radius)
        let point3 = CGPoint(x: topRightPoint.x, y: topRightPoint.y+radius*2)
        context.addArc(tangent1End: CGPoint(x: topRightPoint.x, y: topRightPoint.y+radius), tangent2End: point3, radius: radius)
        let point4 = CGPoint(x: bottomRightPoint.x-radius, y: bottomRightPoint.y)
        context.addArc(tangent1End: bottomRightPoint, tangent2End: point4, radius: radius)
        let point5 = CGPoint(x: bottomLeftPoint.x, y: bottomLeftPoint.y-radius)
        context.addArc(tangent1End: bottomLeftPoint, tangent2End: point5, radius: radius)
        
        context.closePath()
        bgColor.set()
        context.drawPath(using: .fill)
    }
    func drawShowTxt(txtColor:UIColor,rect:CGRect) -> Void {
        
        if let showTxt = self.showTxt {
            let font = UIFont.systemFont(ofSize: 12)
            let txtSize = showTxt.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 20),options: .usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font:font],context: nil)
            
            let textRect = CGRect(x: (rect.width-txtSize.width)/2, y: (rect.height-txtSize.height)/2, width: txtSize.width, height: txtSize.height)
            (showTxt as NSString).draw(in: textRect, withAttributes: [NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor:txtColor])
        }
    }
    
    func drawAwardCountCircle(context:CGContext,rect:CGRect) -> Void {
        
        if self.awardCount>1 {
            
            // 园点坐标
            var center:CGPoint = CGPoint(x: rect.origin.x + rect.size.width / 2, y: rect.origin.y + rect.size.height / 2)
            center.x = center.x+rect.size.width / 4
            center.y = center.y-rect.size.height / 4
            // 圆形半径
            let radius: CGFloat = (min(rect.width, rect.height) - 4)/4-2
            // 设置圆形
            context.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
            var smallBgColor = self.smallCircleBgColor;
            if (smallBgColor == nil) {
                smallBgColor = UIColor.black
            }
            smallBgColor!.set()
            context.drawPath(using: .fill)

            // 画右上角的数字，有些彩种算前三这种模式，一个数字可能在多个位上一页，比如 2 3 2 4 5，前三中2就重复了
            let font = UIFont.systemFont(ofSize: 10)
            let txt = String(format: "%ld", self.awardCount)
            let textSize = txt.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 10),options: .usesLineFragmentOrigin,attributes: [NSAttributedStringKey.font:font],context: nil)
            
            let x: CGFloat = rect.width/2+(rect.width/2-textSize.width)/2
            let y: CGFloat = (rect.height/2-textSize.height)/2
            let textRect = CGRect(x: x, y: y, width: textSize.width, height: textSize.height)
            var smallTxtColor = self.smallCircleTxtColor;
            if (smallTxtColor == nil) {
                smallTxtColor = UIColor.white
            }
            (txt as NSString).draw(in: textRect, withAttributes: [NSAttributedStringKey.font:font,NSAttributedStringKey.foregroundColor:smallTxtColor!])
            
        }
        
    }
}
