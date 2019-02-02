//
//  LFTrendDrawLineModel.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 02/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFTrendDrawLineModel: NSObject {
    var frameList: [LFTrendOutputOmiItemModel] = []
    // 默认线的颜色为红色
    var lineColor: UIColor = UIColor.red
    // 默认线的宽度为1
    var lineWith: CGFloat = 2
}

class DrawLineClosureTool: NSObject {
    static func getNormalAwardClosure(lineColor: UIColor = UIColor.red) -> DrawTrendLineBlock {
    return { (omiList:[LFTrendOutputOmiRowModel]) -> LFTrendDrawLineModel in
        let drawLineModel = LFTrendDrawLineModel()
        var frameList: [LFTrendOutputOmiItemModel] = []
        for rowModel in omiList {
            if rowModel.isWaitOpen {
                continue
            }
            for itemModel in rowModel.subList {
                if itemModel.isAward {
                    frameList.append(itemModel)
                }
            }
        }
        drawLineModel.lineColor = lineColor
        drawLineModel.frameList = frameList
        return drawLineModel
        }
    }
    
    static func getAwardClosure(containsTxts:[String],lineColor: UIColor = UIColor.purple) -> DrawTrendLineBlock {
        return { (omiList:[LFTrendOutputOmiRowModel]) -> LFTrendDrawLineModel in
            let drawLineModel = LFTrendDrawLineModel()
            var frameList: [LFTrendOutputOmiItemModel] = []
            for rowModel in omiList {
                if rowModel.isWaitOpen {
                    continue
                }
                for itemModel in rowModel.subList {
                    if itemModel.isAward && containsTxts.contains(itemModel.colTxt) {
                        frameList.append(itemModel)
                    }
                }
            }
            drawLineModel.lineColor = lineColor
            drawLineModel.frameList = frameList
            return drawLineModel
        }
    }
    static func getAwardClosure(notContainsTxts:[String],lineColor: UIColor = UIColor.purple) -> DrawTrendLineBlock {
        return { (omiList:[LFTrendOutputOmiRowModel]) -> LFTrendDrawLineModel in
            let drawLineModel = LFTrendDrawLineModel()
            var frameList: [LFTrendOutputOmiItemModel] = []
            for rowModel in omiList {
                if rowModel.isWaitOpen {
                    continue
                }
                for itemModel in rowModel.subList {
                    if itemModel.isAward && !notContainsTxts.contains(itemModel.colTxt) {
                        frameList.append(itemModel)
                    }
                }
            }
            drawLineModel.lineColor = lineColor
            drawLineModel.frameList = frameList
            return drawLineModel
        }
    }
}

class MapInputModelClosureTool: NSObject {
    static func getNormalMapClosure(range: NSRange) -> MapTrendInputBlock {
     return   {(orginList:[Any]) -> [LFTrendInputParamModel] in
            return orginList.map { (obj :Any) -> LFTrendInputParamModel in
                let dict = obj as! [String:Any]
                let model = LFTrendInputParamModel()
                model.orginObj = dict
                let numsTxt: String = dict["nums"] as! String
                let nums: [String] =  numsTxt.components(separatedBy: ",")
                
                if nums.count > 0 {
                    let from = range.location
                    var to = from + range.length-1
                    if to >= nums.count {
                        to = nums.count-1
                    }
                    
                    var redTxts: [String] = []
                    for i in from...to {
                        redTxts.append(nums[i])
                    }
                    model.beforeTransformTxt = redTxts.joined(separator: ",")
                    model.afterTransformTxts = redTxts
                    model.isWaitOpen = false
                }else{
                    model.isWaitOpen = true
                }
                return model
            }
        }
    }
}
