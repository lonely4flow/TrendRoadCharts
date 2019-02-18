//
//  LFRoadChartCollectionViewCell.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit


/// 只有在大路计算方式为Combine，也就是标准百家乐的时候才会有和的数量
public enum LFRoadChartCollectionViewCellHeCountShowStyle {
    
    case line // 和的数量的绿色的斜线
    case numTxt // 和的数量的绿色文字
    case none // 不显示
}
/// 问路图上有数据的部分的展示样式
public enum LFRoadChartCollectionViewCellBgStyle {
    
    case hollowCircle // 中间空白的圆圈⭕️
    case solidCircle // 实心圆
    case solidLine // 斜线
    case none // 不显示
}
class LFRoadChartCollectionViewCell: UICollectionViewCell {
    var cellItemSize: CGSize!
    
    var bgStyle: LFRoadChartCollectionViewCellBgStyle = .none
    var bgColor: UIColor = UIColor.red /*展示的内容（圆圈、实心圆、斜线的颜色）*/
    
    var heCountStyle: LFRoadChartCollectionViewCellHeCountShowStyle = .line /*大路上合并和后连续出现的和的数量的展示方式*/
    var heCount: Int = 0 /*大路上合并和后连续出现的和的数量*/
    var heCountColor: UIColor = UIColor.green /*大路上合并和后连续出现的和的颜色*/
    
    var showTxt: String = "" /*需要展示的文字*/
    var txtColor: UIColor = UIColor.white /*需要展示的文字的颜色*/
    var txtFont: UIFont = UIFont.systemFont(ofSize: 10) /*需要展示的文字的字体*/
    
    var seperatorLineColor: UIColor = UIColor.white /*分割线的颜色*/
    var isLastCol: Bool = false /*是否是最后一列，只有最有一列才会在右侧画一条分割线*/
    var isLastRow: Bool = false /*是否是最后一行，只有最有一行才会在底侧画一条分割线*/
    
    var isAskRoadCell: Bool = false {
        didSet {
            self.stopOpacityAnim()
            self.startOpacityAnim()
        }
    } /*是否是用于展示问路动画的cell*/
    var askAnimColor: UIColor = UIColor.white
    private var animlayer: CAShapeLayer?
    
    func startOpacityAnim() -> Void
    {
        self.stopOpacityAnim()
        if !self.isAskRoadCell {
            return
        }
        self.animlayer = CAShapeLayer()
        let margin: CGFloat = 1
        self.animlayer?.frame = CGRect(x: margin, y: margin, width: self.cellItemSize.width-margin*2, height: self.cellItemSize.height-margin*2)
        self.animlayer?.backgroundColor = self.askAnimColor.cgColor
        self.layer.addSublayer(self.animlayer!)

        let animation: CAKeyframeAnimation = CAKeyframeAnimation()
        animation.keyPath = "opacity"
        animation.values = [0.0,1.0,0.0]
        animation.duration = 1.0
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        self.animlayer!.add(animation, forKey: "opactiyAnim")
        
    }
    func stopOpacityAnim() -> Void
    {
        self.animlayer?.removeAllAnimations()
        if self.animlayer?.superlayer != nil {
            self.animlayer?.removeFromSuperlayer()
        }
        self.animlayer = nil
    }
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        // 获取上下文/创建画布
        let context = UIGraphicsGetCurrentContext()
        
        // 画边框分割线
        self .drawBorderSperatorLine(context: context)
        
        // 画内容背景
        switch self.bgStyle {
        case .hollowCircle:
            // 画空心圆
            let margin: CGFloat = 2
            let rect = CGRect(x: margin, y: margin, width: self.cellItemSize.width-margin*2, height: self.cellItemSize.height-margin*2)
            LFDrawTool.lf_drawCircle(rect: rect, bgColor: self.bgColor, context: context,lineWidth: 2,isHellow: true)
        case .solidCircle:
            // 画实心圆
            let margin: CGFloat = 2
            let rect = CGRect(x: margin, y: margin, width: self.cellItemSize.width-margin*2, height: self.cellItemSize.height-margin*2)
            LFDrawTool.lf_drawCircle(rect: rect, bgColor: self.bgColor, context: context)
        case .solidLine:
            // 画斜线
            let margin: CGFloat = 2
            let startPoint = CGPoint(x: margin, y: self.cellItemSize.height-margin)
            let endPoint = CGPoint(x: self.cellItemSize.width-margin, y: margin)
            LFDrawTool.lf_drawLine(startPoint: startPoint, endPoint: endPoint, lineColor: self.bgColor, lineWith: 2, context: context)
        default:
            // 无背景的什么也不画
            break
        }
        
        // 画文字
        LFDrawTool.lf_drawTxt(txt: self.showTxt, font: self.txtFont, color: self.txtColor, rect: rect, context: context)
        
        
        // 画和的数量
        self.drawHeCount(rect: rect, context: context)
    }
    fileprivate func drawBorderSperatorLine(context:CGContext?) -> Void
    {
        // 画顶侧的线
        LFDrawTool.lf_drawLine(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: self.cellItemSize.width, y: 0), lineColor: self.seperatorLineColor, lineWith: 1, context: context)
        // 画左侧的线
        LFDrawTool.lf_drawLine(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: self.cellItemSize.height), lineColor: self.seperatorLineColor, lineWith: 1, context: context)
        if self.isLastCol {
            // 画右侧的线
            LFDrawTool.lf_drawLine(startPoint: CGPoint(x: self.cellItemSize.width, y:0), endPoint: CGPoint(x: self.cellItemSize.width, y: self.cellItemSize.height), lineColor: self.seperatorLineColor, lineWith: 1, context: context)
        }
        if self.isLastRow {
            // 画底侧的线
            LFDrawTool.lf_drawLine(startPoint: CGPoint(x: 0, y:self.cellItemSize.height), endPoint: CGPoint(x: self.cellItemSize.width, y: self.cellItemSize.height), lineColor: self.seperatorLineColor, lineWith: 1, context: context)
        }
    }
    // 画和的数量
    fileprivate func drawHeCount(rect:CGRect,context:CGContext?) -> Void
    {
        if self.heCount <= 0 {
            return
        }
        switch self.heCountStyle {
        case .numTxt:
            LFDrawTool.lf_drawTxt(txt: String(self.heCount), font: UIFont.systemFont(ofSize: 11), color: self.heCountColor, rect: rect, context: context)
        case .line:
            let dis: CGFloat = 3
            let width: CGFloat = rect.width
            let height: CGFloat = rect.height
            let middelIndex: Int = self.heCount / 2
            if self.heCount % 2 == 0 {
                // 偶数条线
                for i in 0..<self.heCount {
                    if i < middelIndex {
                        // 上侧的线
                        let x1: CGFloat = 0
                        let y1: CGFloat = height-CGFloat(middelIndex-i)*dis
                        let startPoint = CGPoint(x: x1+2, y: y1-2)
                        let y2: CGFloat = 0
                        let x2: CGFloat = (y1/height)*width
                        let endPoint = CGPoint(x: x2-2, y: y2+2)
                        LFDrawTool.lf_drawLine(startPoint: startPoint, endPoint: endPoint, lineColor: self.heCountColor, lineWith: 1.5, context: context)
                    }else{
                        // 下侧的线
                        let y2: CGFloat = CGFloat(i-middelIndex+1)*dis
                        let x2: CGFloat = width
                        let endPoint = CGPoint(x: x2-2, y: y2+2)
                        let x1: CGFloat = y2/height*width
                        let y1: CGFloat = height
                        let startPoint = CGPoint(x: x1+2, y: y1-2)
                        
                        LFDrawTool.lf_drawLine(startPoint: startPoint, endPoint: endPoint, lineColor: self.heCountColor, lineWith: 1.5, context: context)
                    }
                }
            }else{
                // 奇数条线
                for i in 0..<self.heCount {
                    if i < middelIndex {
                        // 上侧的线
                        let x1: CGFloat = 0
                        let y1: CGFloat = height-CGFloat(middelIndex-i)*dis
                        let startPoint = CGPoint(x: x1+2, y: y1-2)
                        let y2: CGFloat = 0
                        let x2: CGFloat = (y1/height)*width
                        let endPoint = CGPoint(x: x2-2, y: y2+2)
                        LFDrawTool.lf_drawLine(startPoint: startPoint, endPoint: endPoint, lineColor: self.heCountColor, lineWith: 1.5, context: context)
                    }else if i == middelIndex {
                        // 中间的线
                        let x1: CGFloat = 0
                        let y1: CGFloat = height
                        let startPoint = CGPoint(x: x1+2, y: y1-2)
                        let y2: CGFloat = 0
                        let x2: CGFloat = width
                        let endPoint = CGPoint(x: x2-2, y: y2+2)
                        LFDrawTool.lf_drawLine(startPoint: startPoint, endPoint: endPoint, lineColor: self.heCountColor, lineWith: 1.5, context: context)
                    }
                    else{
                        // 下侧的线
                        let y2: CGFloat = CGFloat(i-middelIndex)*dis
                        let x2: CGFloat = width
                        let endPoint = CGPoint(x: x2-2, y: y2+2)
                        let x1: CGFloat = y2/height*width
                        let y1: CGFloat = height
                        let startPoint = CGPoint(x: x1+2, y: y1-2)
                        
                        LFDrawTool.lf_drawLine(startPoint: startPoint, endPoint: endPoint, lineColor: self.heCountColor, lineWith: 1.5, context: context)
                    }
                }
                
            }
        default:
            break
        }
    }
    
}
