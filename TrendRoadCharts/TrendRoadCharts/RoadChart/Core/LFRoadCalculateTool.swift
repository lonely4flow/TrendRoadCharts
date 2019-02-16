//
//  LFRoadCalculateTool.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 15/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import Foundation
public enum LFRoadCalculateHeType {
    
    case LFRoadCalculateHeTypeCombine // 和与非和的数据展示在一格里
    case LFRoadCalculateHeTypeNextRow // 和展示在同一列的新的一行里
    case LFRoadCalculateHeTypeNextCol // 和展示在新的一列里
    
}
public enum LFRoadCalculateBottomThreeType {
    
    case LFRoadCalculateBottomThreeTypeBigEyeRoad // 大眼路
    case LFRoadCalculateBottomThreeTypeSmallRoad // 小路
    case LFRoadCalculateBottomThreeTypeYueYouRoad // 曱甴路
    
}

/**
 * 问路图计算说明
 * @link: https://666.d88agqj.com/aggame/rules/aggame/rule_home.html
 * @link: https://youxi899.com/百家乐看路法上篇/
 * @link: https://youxi899.com/百家乐看路法下篇/
 */
class LFRoadCalculateTool: NSObject {

    // MARK: - 大路
    // MARK: - n列n行的大路图源数据 Open
    public class func calculateInputListToBigRoadOriginList(inputList:[LFRoadInputParamModel],heType:LFRoadCalculateHeType,callback: ((_ originList: [[LFRoadOutputParamModel]])-> Void)?) -> Operation
    {
        let operation: Operation = BlockOperation {
            let bigRoadOriginList = LFRoadCalculateTool.calculateInputListToBigRaodOriginList(inputList: inputList, heType: heType)
            if callback != nil {
                // 在主线程执行回调
                if Thread.isMainThread {
                    callback!(bigRoadOriginList)
                }else{
                    DispatchQueue.main.async {
                        callback!(bigRoadOriginList)
                    }
                    
                }
                
            }
        }
        return  operation
    }
    // MARK: n列6行的大路图图展示数据 Open
    public class func calculateInputListToBigRoadShowList(inputList:[LFRoadInputParamModel],heType:LFRoadCalculateHeType,callback: ((_ showList: [[AnyObject]])-> Void)?) -> Operation
    {
        let operation: Operation = BlockOperation {
            let bigRoadOriginList = LFRoadCalculateTool.calculateInputListToBigRaodOriginList(inputList: inputList, heType: heType)
            let bigRoadShowList = LFRoadCalculateTool.calculateOutputOriginListToOutputShowList(outputOriginList: bigRoadOriginList)
            if callback != nil {
                // 在主线程执行回调
                if Thread.isMainThread {
                    callback!(bigRoadShowList)
                }else{
                    DispatchQueue.main.async {
                        callback!(bigRoadShowList)
                    }
                    
                }
                
            }
        }
        return  operation
    }
    // MARK: - 大路源数据 private
    // MARK: - n行n列的大路图源数据
    /// 将input数据转换成n列n行的大路图源数据
    ///
    /// - Parameters:
    ///   - inputList: 格式化好的计算参数
    ///   - heType: 和的计算的处理方式
    /// - Returns: 大路图源数据
    fileprivate class func calculateInputListToBigRaodOriginList(inputList: [LFRoadInputParamModel],heType:LFRoadCalculateHeType) -> [[LFRoadOutputParamModel]]
    {
        switch heType {
        case .LFRoadCalculateHeTypeNextRow:
            return LFRoadCalculateTool.calculateInputListToBigRaodOriginListWithHeNextRow(inputList: inputList)
        case .LFRoadCalculateHeTypeNextCol:
            return LFRoadCalculateTool.calculateInputListToBigRaodOriginListWithHeNextCol(inputList: inputList)
        default:
            return LFRoadCalculateTool.calculateInputListToBigRaodOriginListWithHeCombine(inputList: inputList)
        }
    }
    // MARK: 将“和”另起一行的方式n行n列的大路图源数据 private
    /// 将input数据按“和”另起一行展示的方式转换成大路图源数据
    ///
    /// - Parameter inputList: 格式化好的计算参数
    /// - Returns: 大路图源数据
    fileprivate class func calculateInputListToBigRaodOriginListWithHeNextRow(inputList: [LFRoadInputParamModel]) -> [[LFRoadOutputParamModel]]
    {
        var outputOriginList: [[LFRoadOutputParamModel]] = []
        for inputModel in inputList
        {
            if inputModel.isWaitOpen {
                // 对等待开奖的直接忽略
                continue
            }
            let newOutputModel = LFRoadOutputParamModel()
            newOutputModel.showTxt = inputModel.afterTransformTxt
            newOutputModel.inputModel = inputModel
            newOutputModel.heCount = 0
            // 获得最后一列的数组，如果数组不存在，添加一列
            if outputOriginList.last == nil {
                // 添加新的一列
                var newColList: [LFRoadOutputParamModel] = []
                newColList.append(newOutputModel)
                outputOriginList.append(newColList)
            }else {
                var lastColList: [LFRoadOutputParamModel] = outputOriginList.last!
                if "和" == newOutputModel.showTxt {
                    // 如果与上一次添加的一样，则继续在该列添加
                    lastColList.append(newOutputModel)
                }else{
                    // 计算上一次添加的那一列里非和的数据
                    var lastNotHeIndex = lastColList.count-1
                    // 非和的数据
                    var colShowTxt = lastColList[lastNotHeIndex].showTxt
                    while "和" == colShowTxt && lastNotHeIndex > 0 {
                        lastNotHeIndex -= 1
                        colShowTxt = lastColList[lastNotHeIndex].showTxt
                    }
                    
                    if "和" == colShowTxt {
                        // 这一列里全是和的情况，继续在这一列里添加
                        lastColList.append(newOutputModel)
                    }else{
                        if colShowTxt == newOutputModel.showTxt {
                            // 最新的内容和这一列的非和的展示内容一致，继续在这一列里添加
                            lastColList.append(newOutputModel)
                        }else{
                            // 最新的内容和这一列的非和的展示内容不一致，重新添加一列
                            var newColList: [LFRoadOutputParamModel] = []
                            newColList.append(newOutputModel)
                            outputOriginList.append(newColList)
                        }
                    }
                }
            }
            
            
        }
        return outputOriginList
    }
    // MARK: 将“和”另起一列的方式n行n列的大路图源数据 private
    /// 将input数据按“和”另起一列展示的方式转换成大路图源数据
    ///
    /// - Parameter inputList: 格式化好的计算参数
    /// - Returns: 大路图源数据
    fileprivate class func calculateInputListToBigRaodOriginListWithHeNextCol(inputList: [LFRoadInputParamModel]) -> [[LFRoadOutputParamModel]]
    {
        var outputOriginList: [[LFRoadOutputParamModel]] = []
        for inputModel in inputList
        {
            if inputModel.isWaitOpen {
                // 对等待开奖的直接忽略
                continue
            }
            let newOutputModel = LFRoadOutputParamModel()
            newOutputModel.showTxt = inputModel.afterTransformTxt
            newOutputModel.inputModel = inputModel
            newOutputModel.heCount = 0
            // 获得最后一列的数组，如果数组不存在，添加一列
            if outputOriginList.last == nil {
                // 添加新的一列
                var newColList: [LFRoadOutputParamModel] = []
                newColList.append(newOutputModel)
                outputOriginList.append(newColList)
            }else {
                var lastColList: [LFRoadOutputParamModel] = outputOriginList.last!
                let oldOutputModel = lastColList.last!
                if oldOutputModel.showTxt == newOutputModel.showTxt {
                    // 如果与上一次添加的一样，则继续在该列添加
                    lastColList.append(newOutputModel)
                }else{
                    // 最新的内容和这一列的非和的展示内容不一致，重新添加一列
                    var newColList: [LFRoadOutputParamModel] = []
                    newColList.append(newOutputModel)
                    outputOriginList.append(newColList)
                }
            }
            
            
        }
        return outputOriginList
    }
    // MARK: 将“和”与前一个非和的合并展示的方式n行n列的大路图源数据 private
    /// 将input数据按“和”与前一个非和数据合并展示的方式转换成大路图源数据
    ///
    /// - Parameter inputList: 格式化好的计算参数
    /// - Returns: 大路图源数据
    fileprivate class func calculateInputListToBigRaodOriginListWithHeCombine(inputList: [LFRoadInputParamModel]) -> [[LFRoadOutputParamModel]]
    {
        var outputOriginList: [[LFRoadOutputParamModel]] = []
        for inputModel in inputList
        {
            if inputModel.isWaitOpen {
                // 对等待开奖的直接忽略
                continue
            }
            let newOutputModel = LFRoadOutputParamModel()
            newOutputModel.showTxt = inputModel.afterTransformTxt
            newOutputModel.inputModel = inputModel
            newOutputModel.heCount = 0
            // 获得最后一列的数组，如果数组不存在，添加一列
            if outputOriginList.last == nil {
                // 添加新的一列
                var newColList: [LFRoadOutputParamModel] = []
                newColList.append(newOutputModel)
                outputOriginList.append(newColList)
            }else {
                
                var lastColList: [LFRoadOutputParamModel] = outputOriginList.last!
                let oldOutputModel = lastColList.last!
                if "和" == newOutputModel.showTxt {
                    // 与上一行的内容合并
                    oldOutputModel.heCount += 1
                }else{
                    if "和" == oldOutputModel.showTxt {
                        // 上一列之前添加的一直是和的情况，这种只会出现第一个数据就是和，直到这个数据前的数据都是和
                        // 用当前这个非和的数据替换之前的数据
                        oldOutputModel.showTxt = newOutputModel.showTxt
                        oldOutputModel.inputModel = newOutputModel.inputModel
                        oldOutputModel.heCount += 1
                    }else{
                        if oldOutputModel.showTxt == newOutputModel.showTxt {
                            // 与上一次添加的属于同一个类型，继续在该列添加数据
                            lastColList.append(newOutputModel)
                        }else{
                            // 与上一列数据不一致，新添加一列
                            var newColList: [LFRoadOutputParamModel] = []
                            newColList.append(newOutputModel)
                            outputOriginList.append(newColList)
                        }
                    }
                }
            }
            
            
        }
        return outputOriginList
    }
    
    // MARK: - 将n列n行的源数据转换成n列6行的显示数据 private
    /// 将n列n行的数据转换成标准的n列6行的展示数据
    ///
    /// - Parameter outputOriginList: 源数据
    /// - Returns: 展示数据
    fileprivate class func calculateOutputOriginListToOutputShowList(outputOriginList: [[LFRoadOutputParamModel]]) -> [[AnyObject]]
    {
        // 大路图上的n列的数组，每列有6行
        let outputShowList: [[AnyObject]] = []
        for originColList in outputOriginList {
            // 从后往前找，找到第一行时空数据的列
            var lastFirstRowEmptyColList = outputShowList.lf_road_findFirstRowEmptyColList()
            let maxEmptyIndex = lastFirstRowEmptyColList.lf_road_findMaxEmptyIndex()

            for rowIndex in 0..<originColList.count
            {
                let outputModel = originColList[rowIndex]
                if rowIndex <= maxEmptyIndex
                {
                    lastFirstRowEmptyColList[rowIndex] = outputModel
                }
                else{
                   // 要长龙折行展示
                    var nextColList: [AnyObject] = outputShowList.lf_road_nextColListWithRowIndex(rowIndex: maxEmptyIndex)
                    nextColList[maxEmptyIndex] = outputModel
                }
            }
        }
        return outputShowList
    }
    // MARK: - 盘珠路
    // MARK: - n列6行的盘珠路展示数据 Open
    public class func calculateInputListToPanzhuShowList(inputList:[LFRoadInputParamModel],heType:LFRoadCalculateHeType,bottomThreeRoadType:LFRoadCalculateBottomThreeType,callback: ((_ showList: [[AnyObject]])-> Void)?) -> Operation
    {
        let operation: Operation = BlockOperation {
            let showList = LFRoadCalculateTool.calculateInputListToPanzhuRoadOutputShowList(inputList: inputList)
            if callback != nil {
                // 在主线程执行回调
                if Thread.isMainThread {
                    callback!(showList)
                }else{
                    DispatchQueue.main.async {
                        callback!(showList)
                    }
                    
                }
                
            }
        }
        return  operation
    }
    // MARK: 将格式化号的数据转换成珠盘路显示数据 private
    /// 将格式化号的数据转换成珠盘路显示数据 private
    ///
    /// - Parameter inputList: 输入参数
    /// - Returns: 盘珠路显示数据
    fileprivate class func calculateInputListToPanzhuRoadOutputShowList(inputList: [LFRoadInputParamModel]) -> [[AnyObject]]
    {
        var showList: [[AnyObject]] = []
        for inputModel in inputList {
            // 等待开奖的直接忽略
            if inputModel.isWaitOpen {
                continue
            }
            
            var lastColList: [AnyObject]!
            if showList.last == nil {
                // 如果之前没有添加过数据，添加一列
                lastColList = []
                showList.append(lastColList)
            }else{
                // 使用最后一列
                lastColList = showList.last!
            }
            // 放了6个内容后就要换新的列展示数据
            if lastColList.count >= 6 {
                lastColList = []
                showList.append(lastColList)
            }
            let newOutputModel = LFRoadOutputParamModel()
            newOutputModel.showTxt = inputModel.afterTransformTxt
            newOutputModel.inputModel = inputModel
            newOutputModel.heCount = 0
            lastColList.append(newOutputModel)
            
        }
        // 对最后一列补全满足每列都6行
        if let lastColList = showList.last {
            let emptyCount: Int = 6-lastColList.count
            lastColList.lf_addObj(count:emptyCount,obj:NSNull())
        }
        
        return showList
    }
    // MARK: - 下三路
    // MARK: - n列n行的下三路三个图源数据 Open
    public class func calculateInputListToBottomThreeOriginList(inputList:[LFRoadInputParamModel],heType:LFRoadCalculateHeType,callback: ((_ bigEyeRoadOriginList: [[LFRoadOutputParamModel]],_ smallRoadOriginList: [[LFRoadOutputParamModel]],_ yueYouRoadOriginList: [[LFRoadOutputParamModel]])-> Void)?) -> Operation
    {
        let operation: Operation = BlockOperation {
            let bigRoadOriginList = LFRoadCalculateTool.calculateInputListToBigRaodOriginList(inputList: inputList, heType: heType)
            let bigEyeRoadOriginList = LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList:bigRoadOriginList,bottomThreeRoadType:.LFRoadCalculateBottomThreeTypeBigEyeRoad)
            let smallRoadOriginList = LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList:bigRoadOriginList,bottomThreeRoadType:.LFRoadCalculateBottomThreeTypeSmallRoad)
            let yueYouRoadOriginList = LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList:bigRoadOriginList,bottomThreeRoadType:.LFRoadCalculateBottomThreeTypeYueYouRoad)
            
            if callback != nil {
                // 在主线程执行回调
                if Thread.isMainThread {
                    callback!(bigEyeRoadOriginList,smallRoadOriginList,yueYouRoadOriginList)
                }else{
                    DispatchQueue.main.async {
                        callback!(bigEyeRoadOriginList,smallRoadOriginList,yueYouRoadOriginList)
                    }
                    
                }
                
            }
        }
        return  operation
    }
    // MARK: n列6行的下三路三个图展示数据 Open
    public class func calculateInputListToBottomThreeShowList(inputList:[LFRoadInputParamModel],heType:LFRoadCalculateHeType,callback: ((_ bigEyeRoadShowList: [[AnyObject]],_ smallRoadShowList: [[AnyObject]],_ yueYouRoadShowList: [[AnyObject]])-> Void)?) -> Operation
    {
        let operation: Operation = BlockOperation {
            let bigRoadOriginList = LFRoadCalculateTool.calculateInputListToBigRaodOriginList(inputList: inputList, heType: heType)
            
            let bigEyeRoadOriginList = LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList:bigRoadOriginList,bottomThreeRoadType:.LFRoadCalculateBottomThreeTypeBigEyeRoad)
            let bigEyeRoadShowList = LFRoadCalculateTool.calculateOutputOriginListToOutputShowList(outputOriginList: bigEyeRoadOriginList)
            
            let smallRoadOriginList = LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList:bigRoadOriginList,bottomThreeRoadType:.LFRoadCalculateBottomThreeTypeSmallRoad)
            let smallRoadShowList = LFRoadCalculateTool.calculateOutputOriginListToOutputShowList(outputOriginList: smallRoadOriginList)
            
            let yueYouRoadOriginList = LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList:bigRoadOriginList,bottomThreeRoadType:.LFRoadCalculateBottomThreeTypeYueYouRoad)
            let yueYouRoadShowList = LFRoadCalculateTool.calculateOutputOriginListToOutputShowList(outputOriginList: yueYouRoadOriginList)
            
            if callback != nil {
                // 在主线程执行回调
                if Thread.isMainThread {
                    callback!(bigEyeRoadShowList,smallRoadShowList,yueYouRoadShowList)
                }else{
                    DispatchQueue.main.async {
                        callback!(bigEyeRoadShowList,smallRoadShowList,yueYouRoadShowList)
                    }
                    
                }
                
            }
        }
        return  operation
    }
    // MARK: - n列n行的下三路单个图源数据 Open
    public class func calculateInputListToBottomThreeOriginList(inputList:[LFRoadInputParamModel],heType:LFRoadCalculateHeType,bottomThreeRoadType:LFRoadCalculateBottomThreeType,callback: ((_ originList: [[LFRoadOutputParamModel]])-> Void)?) -> Operation
    {
        let operation: Operation = BlockOperation {
            let bigRoadOriginList = LFRoadCalculateTool.calculateInputListToBigRaodOriginList(inputList: inputList, heType: heType)
            let bottomThreeOriginList = LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList:bigRoadOriginList,bottomThreeRoadType:bottomThreeRoadType)
            if callback != nil {
                // 在主线程执行回调
                if Thread.isMainThread {
                    callback!(bottomThreeOriginList)
                }else{
                    DispatchQueue.main.async {
                        callback!(bottomThreeOriginList)
                    }
                    
                }
                
            }
        }
        return  operation
    }
    // MARK: n列6行的下三路单个图展示数据 Open
    public class func calculateInputListToBottomThreeShowList(inputList:[LFRoadInputParamModel],heType:LFRoadCalculateHeType,bottomThreeRoadType:LFRoadCalculateBottomThreeType,callback: ((_ showList: [[AnyObject]])-> Void)?) -> Operation
    {
        let operation: Operation = BlockOperation {
            let bigRoadOriginList = LFRoadCalculateTool.calculateInputListToBigRaodOriginList(inputList: inputList, heType: heType)
            let bottomThreeOriginList = LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList:bigRoadOriginList,bottomThreeRoadType:bottomThreeRoadType)
            let bottomThreeShowList = LFRoadCalculateTool.calculateOutputOriginListToOutputShowList(outputOriginList: bottomThreeOriginList)
            if callback != nil {
                // 在主线程执行回调
                if Thread.isMainThread {
                    callback!(bottomThreeShowList)
                }else{
                    DispatchQueue.main.async {
                        callback!(bottomThreeShowList)
                    }
                    
                }
                
            }
        }
        return  operation
    }
    // MARK: - 大路源数据转换成下三路源数据 private
    fileprivate class func calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList:[[LFRoadOutputParamModel]],bottomThreeRoadType: LFRoadCalculateBottomThreeType) -> [[LFRoadOutputParamModel]]
    {
        switch bottomThreeRoadType {
        case .LFRoadCalculateBottomThreeTypeBigEyeRoad:
            return LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList: bigRoadOriginList, startColNum: 1)
        case .LFRoadCalculateBottomThreeTypeSmallRoad:
            return LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList: bigRoadOriginList, startColNum: 2)
        default:
            return LFRoadCalculateTool.calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList: bigRoadOriginList, startColNum: 3)
        }
    }
    // MARK: - 大路源数据转换成下三路源数据 private
    fileprivate class func calculateBigRoadOriginListToBottomThreeOriginList(bigRoadOriginList:[[LFRoadOutputParamModel]],startColNum: Int) -> [[LFRoadOutputParamModel]]
    {
        
        let sepBeforeAfter: String = "&#&"
        let inputList: [LFRoadInputParamModel] = LFRoadCalculateTool.calculateBigRoadListToInputList(bigRoadOriginList: bigRoadOriginList, startColNum: startColNum, sepBeforeAfter: sepBeforeAfter)
        let bottomThreeOriginList: [[LFRoadOutputParamModel]] = LFRoadCalculateTool.calculateInputListToBigRaodOriginListWithHeCombine(inputList: inputList)
        // input/output还原
        for colList in bottomThreeOriginList {
            for outputModel in colList {
                let txts: [String] = outputModel.inputModel.beforeTransformTxt!.components(separatedBy: sepBeforeAfter)
                if let oldBeforeTransformTxt = txts.first {
                    if oldBeforeTransformTxt != "nil" {
                        outputModel.inputModel.beforeTransformTxt = oldBeforeTransformTxt
                    }
                }
                outputModel.inputModel.afterTransformTxt = txts.last!;
            }
        }
        return bottomThreeOriginList;
    }
    // MARK: - 大路源数据转换成下三路源数据 (真正将大路数据转换成下三路数据)private
    fileprivate class func calculateBigRoadListToInputList(bigRoadOriginList:[[LFRoadOutputParamModel]],startColNum: Int,sepBeforeAfter: String) -> [LFRoadInputParamModel]
    {
        // https://666.d88agqj.com/aggame/rules/aggame/rule_home.html
        // https://youxi899.com/百家乐看路法下篇/
        var inputList: [LFRoadInputParamModel] = []
        for colIndex in startColNum..<bigRoadOriginList.count {
            if bigRoadOriginList.count <= colIndex {
                // 对startColNum
                continue
            }
            var colList = bigRoadOriginList[colIndex]
            if colIndex == startColNum && colList.count < 2 {
                // 开始算的那一列如果第二行是空的，则另起一行开始计算
                continue;
            }
            for rowIndex in 0..<colList.count {
                if colIndex == startColNum && rowIndex == 0 {
                    // 计算的第一列的第一行不计算
                    continue
                }
                let outputModel = colList[rowIndex]
                // 前面比较的列
                var preCompareColIndex: Int = colIndex-startColNum
                var preCompareColList: [LFRoadOutputParamModel] = bigRoadOriginList[preCompareColIndex]
                if rowIndex == 0 {
                    // 路头牌
                    preCompareColIndex = colIndex-startColNum-1
                    preCompareColList = bigRoadOriginList[preCompareColIndex]
                    // 相邻的前一列数据
                    let preNearColList = bigRoadOriginList[colIndex-1]
                    // 如果前一列数据量与前前一列数据量相等，则把数据第一行数据加到前一行上会形成一厅两房，是蓝色，换颜色变成红色
                    // 如果前前列数据量比前列数据量少，添加一个则为长庄或长闲，是红色，换颜色变成蓝色
                    // 如果前前列数据量比前列数据量大，添加一个则为拍拍连，是红色，换颜色变成蓝色
                    if preNearColList.count == preCompareColList.count {
                        // 形成对其的，添加一个则为一厅两房，是蓝色，换颜色变成红色
                        let newInputModel: LFRoadInputParamModel = LFRoadInputParamModel()
                        let oldInputModel: LFRoadInputParamModel = outputModel.inputModel
                        newInputModel.originData = oldInputModel.originData
                        newInputModel.beforeTransformTxt = LFRoadCalculateTool.combineTxts(beforeTxt: oldInputModel.beforeTransformTxt, afterTxt: sepBeforeAfter, sepBeforeAfter: oldInputModel.afterTransformTxt)
                        
                        newInputModel.isAskRoad = oldInputModel.isAskRoad
                        newInputModel.afterTransformTxt = "红"
                        inputList.append(newInputModel)
                    }else{
                        // 添加一个，形成拍拍连或长庄长闲，是红色，换颜色变成蓝色
                        let newInputModel: LFRoadInputParamModel = LFRoadInputParamModel()
                        let oldInputModel: LFRoadInputParamModel = outputModel.inputModel
                        newInputModel.originData = oldInputModel.originData
                        newInputModel.beforeTransformTxt = LFRoadCalculateTool.combineTxts(beforeTxt: oldInputModel.beforeTransformTxt, afterTxt: sepBeforeAfter, sepBeforeAfter: oldInputModel.afterTransformTxt)
                        newInputModel.isAskRoad = oldInputModel.isAskRoad
                        newInputModel.afterTransformTxt = "蓝";
                        inputList.append(newInputModel)
                    }
                }else{
                    // 路中牌
                    // 非第一行数据
                    // 如果比较的前一列数据小于当前的行-1，则位一厅两房，位蓝色
                    // 前一列大于等于当前行为拍拍连，为红色
                    // 前一列小于等于当前行-2，为长庄或长闲，为红色
                    if preCompareColList.count == rowIndex {
                        // 一厅两房
                        let newInputModel: LFRoadInputParamModel = LFRoadInputParamModel()
                        let oldInputModel: LFRoadInputParamModel = outputModel.inputModel
                        newInputModel.originData = oldInputModel.originData;
                        newInputModel.beforeTransformTxt = LFRoadCalculateTool.combineTxts(beforeTxt: oldInputModel.beforeTransformTxt, afterTxt: sepBeforeAfter, sepBeforeAfter: oldInputModel.afterTransformTxt)
                        newInputModel.isAskRoad = oldInputModel.isAskRoad
                        newInputModel.afterTransformTxt = "蓝"
                        inputList.append(newInputModel)
                    }else{
                        // 拍拍连或长庄长闲
                        let newInputModel: LFRoadInputParamModel = LFRoadInputParamModel()
                        let oldInputModel: LFRoadInputParamModel = outputModel.inputModel
                        newInputModel.originData = oldInputModel.originData
                        newInputModel.beforeTransformTxt = LFRoadCalculateTool.combineTxts(beforeTxt: oldInputModel.beforeTransformTxt, afterTxt: sepBeforeAfter, sepBeforeAfter: oldInputModel.afterTransformTxt)
                        newInputModel.isAskRoad = oldInputModel.isAskRoad
                        newInputModel.afterTransformTxt = "红"
                        inputList.append(newInputModel)
                    }
                }
            }
        }
        return inputList
    }
    // MARK: - 组合文字 Private
    fileprivate class func combineTxts(beforeTxt: String?,afterTxt:String,sepBeforeAfter: String) -> String
    {
        if beforeTxt != nil {
            return  beforeTxt!+sepBeforeAfter+afterTxt
        }else{
            return  "nil"+sepBeforeAfter+afterTxt
        }
    }
}

// MARK: -
extension Array {
    
    fileprivate func lf_road_findMaxEmptyIndex() -> Int
    {
        var colList: [AnyObject] = self as [AnyObject]
        var maxEmptyIndex = 0
        for i in 0..<self.count {
            let obj: AnyObject = colList[i]
            if !obj.isKind(of: NSNull.classForCoder()) {
                // 如果遇到了不是空的数据，则上一行就是最大的空行了
                return maxEmptyIndex
            }else{
                maxEmptyIndex = i
            }
        }
        return maxEmptyIndex
    }
    fileprivate func lf_road_findFirstRowEmptyColList() -> [AnyObject]
    {
        var showList: [[AnyObject]] = self as! [[AnyObject]]
        if showList.count == 0 || !showList.last!.first!.isKind(of: NSNull.classForCoder()) {
            // 展示数据为空
            // 或展示数据的最后一列的第一行不是null，也就是最后一列的第一行有正式数据，添加新添加一列
            let newColList: [AnyObject] = Array<Any>.lf_fillObj(count:6,obj:NSNull())
            showList.append(newColList)
            return newColList
        }else {
            // 最后一期的第一行时空数据，则表明有空列，找到最后一个非空列
            var lastNotEmptyColIndex: Int = showList.count-2
            var lastNotEmptyList: [AnyObject] = showList[lastNotEmptyColIndex]
            while lastNotEmptyList.first!.isKind(of:NSNull.classForCoder()) && lastNotEmptyColIndex > 0 {
                lastNotEmptyColIndex -= 1
                lastNotEmptyList = showList[lastNotEmptyColIndex]
            }
            // 最后一列非空数据，则取最后一列非空数据的后一列
            let lastEmptyList = showList[lastNotEmptyColIndex+1]
            return lastEmptyList
        }
    }
    fileprivate func lf_road_nextColListWithRowIndex(rowIndex: Int) -> [AnyObject]
    {
        var showList: [[AnyObject]] = self as! [[AnyObject]]
        if !showList.last![rowIndex].isKind(of: NSNull.classForCoder()) {
            // 最后一列都不是空的，则需要新添加一列
            let newColList: [AnyObject] = Array<Any>.lf_fillObj(count:6,obj:NSNull())
            showList.append(newColList)
            return newColList
        }else{
            // 最后一列的这一行是空的，则找到最后一个不为空的，然后找到这列旁边的一列
            var lastNotEmptyColIndex: Int = showList.count-2
            var colList = showList[lastNotEmptyColIndex]
            var rowObj: AnyObject = colList[rowIndex]
            while rowObj.isKind(of: NSNull.classForCoder()) && lastNotEmptyColIndex > 0 {
                lastNotEmptyColIndex -= 1
                colList = showList[lastNotEmptyColIndex]
                rowObj = colList[rowIndex]
            }
            return showList[lastNotEmptyColIndex+1]
        }
    }
}
