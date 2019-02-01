//
//  LFOmiItemFrameModel.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 01/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

/// 用于画连线保存计算位置的model
class LFOmiItemFrameModel: LFTrendOutputOmiItemModel {
    // 真正的位置
    var realRect: CGRect!
    // 中心点
    var center: CGPoint!
    // 开始点
    var startPoint: CGPoint?
    // 结束点
    var endPoint: CGPoint?
    
    convenience init(omiItemModel: LFTrendOutputOmiItemModel) {
        self.init()
        self.omiCount = omiItemModel.omiCount
        self.colTxt = omiItemModel.colTxt
        self.showTxt = omiItemModel.showTxt
        self.awardCount = omiItemModel.awardCount
        self.isAward = omiItemModel.isAward
    }
}
