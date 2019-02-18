//
//  LFRoadAskTipView.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

fileprivate class LFRoadAskTipThreeView : UIView
{
    var askColors: [UIColor]?
    private var animLayer: CAShapeLayer?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 创建画布
        let context = UIGraphicsGetCurrentContext()
        // 大眼路-空心圆
        let margin: CGFloat = 5
        let circleMargin: CGFloat = 2
        let circleWH: CGFloat = rect.height-circleMargin
        let circleY = (rect.height-circleWH)/2
        LFDrawTool.lf_drawCircle(rect: CGRect(x: margin, y: circleY, width: circleWH, height: circleWH), bgColor: self.askColors![0], context: context,lineWidth: 2,isHellow: true)
        // 小路-实心圆
        LFDrawTool.lf_drawCircle(rect: CGRect(x: margin*2+circleWH, y: circleY, width: circleWH, height: circleWH), bgColor: self.askColors![1], context: context,lineWidth: 2)
        // 曱甴路-斜线
        LFDrawTool.lf_drawLine(startPoint: CGPoint(x: (margin+circleWH)*2+margin, y: circleWH-circleMargin), endPoint: CGPoint(x: (margin+circleWH)*3-10, y: circleMargin), lineColor: self.askColors![2], lineWith: 2, context: context)
    }
    
    func stopOpactyAnim() -> Void
    {
        // 先清空layer
        self.animLayer?.removeAllAnimations()
        if self.animLayer?.superlayer != nil {
            self.animLayer?.removeFromSuperlayer()
         }
         self.animLayer = nil
    }
    func startOpactyAnim() -> Void
    {
        self.stopOpactyAnim()
        if self.animLayer == nil {
            return
        }
        self.animLayer = CAShapeLayer()

        let margin: CGFloat  = 0
        self.animLayer!.frame = CGRect(x: margin, y: margin, width: self.frame.width-margin*2, height: self.frame.height-margin*2)
        self.animLayer!.backgroundColor = self.backgroundColor?.cgColor;
        self.layer.addSublayer(self.animLayer!)
    
    
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.fromValue = 0;
    animation.toValue = 1
    animation.autoreverses = true
    animation.duration = 1.0
    animation.repeatCount = MAXFLOAT;
    animation.isRemovedOnCompletion = false
    animation.fillMode = kCAFillModeForwards;
    //animation.timingFunction = [CAMediaTimingFunction
   // functionWithName:kCAMediaTimingFunctionEaseIn]; ///没有的话是均匀的动画。
    self.animLayer?.add(animation, forKey: "opactiyAnim")
    }
}
class LFRoadAskTipView: UIView {

    var title: String? {
        didSet {
            
        }
    }
    var bgColor: UIColor? {
        didSet{
            self.colorLayer?.backgroundColor = self.bgColor?.cgColor
            self.colorLayer?.borderColor = self.bgColor?.cgColor
        }
    }
    var darkColor: UIColor? {
        didSet {
            self.darkView?.backgroundColor = self.darkColor
        }
    }
    var isShowColorAnim: Bool = false
    var bgLayer: CAShapeLayer?
    var colorLayer: CAShapeLayer?
    fileprivate var darkView: LFRoadAskTipThreeView?
    var titleLbl: UILabel?
    
    func setup() -> Void {
        self.bgLayer = CAShapeLayer()
        self.bgLayer?.frame = self.bounds
        self.bgLayer?.masksToBounds = true
        self.bgLayer?.cornerRadius = 5
        self.bgLayer?.borderWidth = 2
        
        self.colorLayer = CAShapeLayer()
        self.colorLayer?.frame = self.bounds
        self.colorLayer?.masksToBounds = true
        self.colorLayer?.borderWidth = 0
        self.layer.addSublayer(self.colorLayer!)
        
        let contentHeight = self.frame.height/2;
        let contentY = (self.frame.height-contentHeight)/2;
        let titleWidth: CGFloat = 50
        let margin: CGFloat = 5
        self.titleLbl = UILabel(frame: CGRect(x: margin, y: contentY, width: titleWidth, height: contentHeight))
        self.titleLbl!.textColor = UIColor.white
        self.titleLbl!.textAlignment = .center;
        self.titleLbl!.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(self.titleLbl!)
        
        
        self.darkView = LFRoadAskTipThreeView(frame: CGRect(x: self.titleLbl!.frame.width+margin, y: contentY, width: 70, height: contentHeight))
        self.darkView!.layer.masksToBounds = true;
        self.darkView!.layer.cornerRadius = self.darkView!.frame.height/2;
        self.addSubview(self.darkView!)
        
    }
    
    class func askTip(withBgColor bgColor: UIColor,darkColor: UIColor,frame: CGRect) -> LFRoadAskTipView
    {
        let tipView = LFRoadAskTipView(frame: frame)
        tipView.setup()
        return tipView
    }
    func updateAskColors(askColors: [UIColor]) -> Void {
        
    }
    func stopDarkAnim() -> Void {
        self.darkView?.stopOpactyAnim()
    }
    func startDarkAnim() -> Void {
        self.darkView?.startOpactyAnim()
    }
    func stopColorAnim() -> Void {
        self.colorLayer!.frame = self.bounds;
        self.colorLayer!.cornerRadius = 5;
        // 先清空layer
        self.bgLayer?.removeAllAnimations()
        if(self.bgLayer?.superlayer != nil){
            self.bgLayer?.removeFromSuperlayer()
        }
        self.isShowColorAnim = false
    }
    func startColorAnim() -> Void {
        self.stopColorAnim()
        self.isShowColorAnim = true
        self.colorLayer?.frame = CGRect(x: 5, y: 5, width: self.frame.width-10, height: self.frame.height-10)
        self.colorLayer?.cornerRadius = 0
        self.layer.insertSublayer(self.bgLayer!, at: 0)
        self.bgLayer?.backgroundColor = UIColor.yellow.cgColor;
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = self.bgColor!.cgColor
        animation.toValue = UIColor.yellow.cgColor
        animation.autoreverses = true
        animation.duration = 0.5
        animation.repeatCount = MAXFLOAT
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards;
//        animation.timingFunction = [CAMediaTimingFunction
//        functionWithName:kCAMediaTimingFunctionEaseIn];
        self.bgLayer?.add(animation, forKey: "colorAnim")
    }
    
}
