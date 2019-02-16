//
//  LFTrendCalculate.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 29/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import Foundation

class LFTrendCalculate: NSObject {
    
    /// 通过开奖数据计算出遗漏及统计部分的数据
    ///
    /// - Parameters:
    ///   - inputList: 输入中奖列表
    ///   - colList: 列头
    ///   - callback: 处理完成后的回调
    open class func calculateOmiAndStatictis(inputList: [LFTrendInputParamModel],colList: [String],callback: @escaping (_ omiList: [LFTrendOutputOmiRowModel],_ statisticsList: [LFTrendOutputStatisticsItemModel])-> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            // 遗漏部分的数据
            let omiList: [LFTrendOutputOmiRowModel] = inputList.map({ (inputModel: LFTrendInputParamModel) -> LFTrendOutputOmiRowModel in
                let omiRowModel = LFTrendOutputOmiRowModel()
                omiRowModel.isWaitOpen = inputModel.isWaitOpen
                omiRowModel.orginObj = inputModel.orginObj
                return omiRowModel
            })
            // 统计部分的数据
            var statisticsList: [LFTrendOutputStatisticsItemModel] = []
            
            // 按照列进行遍历
            for colIndex in 0..<colList.count {
                let colTxt = colList[colIndex]
                // 遗漏数字
                var omiCount = 0
                // 最大遗漏数字
                var maxOmiCount = 0
                // 连出数
                var continueAwardCount = 0
                // 最大连出数
                var maxContinueAwardCount = 0
                // 总中奖数
                var totalAwardCount = 0
                // 总中奖行数
                var totalAwardRowCount = 0
                // 每列都遍历n行
                for rowIndex in 0..<inputList.count {
                    let inputModel = inputList[rowIndex]
                    // 等待开奖的行跳过
                    if inputModel.isWaitOpen {
                        continue
                    }
                    let omiRowModel = omiList[rowIndex]
                    let omiItemModel = LFTrendOutputOmiItemModel()
                    // 已经开奖的比较列标题与转换后的中奖文字数据比较
                    if inputModel.afterTransformTxts.lf_isContain(txt: colTxt) {
                        // 中奖数，比如[2,3,2]中，2中奖2次
                        let awardCount = inputModel.afterTransformTxts.lf_findCount(txt: colTxt)
                        // 遗漏数
                        omiCount = 0
                        // 连续中奖数
                        continueAwardCount += 1
                        // 总中奖行数
                        totalAwardRowCount += 1
                        // 总中奖次数
                        totalAwardCount += awardCount
                        // 最大连续中奖数
                        maxContinueAwardCount = max(maxContinueAwardCount, continueAwardCount)
                        
                        
                        
                        // 列标题在中奖数组里，表示中奖
                        omiItemModel.isAward = true
                        omiItemModel.omiCount = omiCount
                        omiItemModel.awardCount = awardCount
                        omiItemModel.colTxt = colTxt
                        omiItemModel.showTxt = inputModel.afterTransformTxts.lf_findTxt(txt: colTxt)!
                        
                    }else{
                        // 遗漏数
                        omiCount += 1
                        // 连续中奖数
                        continueAwardCount = 0
                        // 最大遗漏数
                        maxOmiCount = max(maxOmiCount,omiCount)
                        
                        // 为中奖
                        omiItemModel.isAward = false
                        omiItemModel.omiCount = omiCount
                        omiItemModel.awardCount = 0
                        omiItemModel.colTxt = colTxt
                        // 展示的是遗漏数字
                        omiItemModel.showTxt = String(format: "%ld", omiCount)
                    }
                    omiRowModel.subList.append(omiItemModel)
                }
                
                // 统计部分的数据
                var avgOmiCount = 0
                if totalAwardCount>0 {
                    avgOmiCount = (inputList.count-totalAwardCount)/totalAwardCount
                }else {
                    avgOmiCount = inputList.count
                }
                
                let statisticsItemModel = LFTrendOutputStatisticsItemModel()
                statisticsItemModel.awardCount = totalAwardCount
                statisticsItemModel.awardRowCount = totalAwardRowCount
                statisticsItemModel.avgOmiCount = avgOmiCount
                statisticsItemModel.maxOmiCount = maxOmiCount
                statisticsItemModel.maxContinueCount = maxContinueAwardCount
                statisticsList.append(statisticsItemModel)
            }
            

            DispatchQueue.main.async {
                callback(omiList,statisticsList)
            }
            
        }
    }
}
