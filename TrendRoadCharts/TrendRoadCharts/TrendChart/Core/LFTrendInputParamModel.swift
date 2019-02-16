//
//  LFTrendInputParamModel.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 30/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import Foundation
// MARK: - 遗漏输入Model
class LFTrendInputParamModel: NSObject {
    // 是否属于等待开奖
    var isWaitOpen:Bool = false
    // 转换成目标文本之前的文本，在计算中不使用，主要方便在UI需要显示原始内容，而不是列头的情况
    var beforeTransformTxt: String?
    // 转换后的文本数组，比如beforeTransformTxt是3，可以转换成[单,小]
    var afterTransformTxts: [String] = [String]()
    // 原始数据
    var orginObj: Any?
}
// MARK: - 遗漏结果行Model
class LFTrendOutputOmiRowModel: NSObject {
    // 是否属于等待开奖
    var isWaitOpen:Bool = false
    // 一行的遗漏数据
    var subList:[LFTrendOutputOmiItemModel] = []
    // 原始数据
    var orginObj: Any?
}
// MARK: 遗漏结果ItemModel
class LFTrendOutputOmiItemModel: NSObject {
    // 遗漏数字，好像没什么用
    var omiCount: Int = 0
    // 列的标题
    var colTxt: String!
    // 要展示的文字，默认如果中奖则展示列标题，没中奖则展示遗漏数字
    var showTxt: String!
    /**出现中奖的个数，如[01,05,01]中，在1的这一列的中奖个数就是2*/
    var awardCount: Int = 0
    // 是否中奖
    var isAward: Bool = false
    
}
// MARK: - 统计结果行Model
class LFTrendOutputStatisticsItemModel: NSObject {
    // 这一列出现的中奖的次数
    var awardCount: Int = 0
    // 这一列出现的中奖的行数
    var awardRowCount: Int = 0
    // 平均遗漏数
    var avgOmiCount: Int = 0
    // 最大遗漏数
    var maxOmiCount: Int = 0
    // 最大连出数
    var maxContinueCount: Int = 0
}
