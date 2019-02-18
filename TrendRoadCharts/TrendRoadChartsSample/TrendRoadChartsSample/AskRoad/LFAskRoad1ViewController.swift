//
//  LFAskRoad1ViewController.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFAskRoad1ViewController: LFAskRoadViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func prepareDataList() -> Void {
        super.prepareDataList()
        let categoryModel = LFAskRoadCategoryModel()
        categoryModel.title = "总和"
        let bigSmallItemModel = LFAskRoadItemModel()
        bigSmallItemModel.title = "大小"
        bigSmallItemModel.askTitles = ["大","小"]
        bigSmallItemModel.isShowBottomThreeRoad = true
        bigSmallItemModel.transformClosure = {(inputModel:LFRoadInputParamModel, obj: AnyObject) in
            if let objDict = obj as? [String : Any] {
                let numsTxt: String = objDict["nums"] as? String ?? ""
                if numsTxt.isEmpty {
                    inputModel.isWaitOpen = true
                }else{
                    inputModel.isWaitOpen = false
                    let nums: [String] = numsTxt.components(separatedBy: ",")
                    var sum: Int = 0
                    for oneNum in nums {
                        sum = sum + Int(oneNum)!
                    }
                    inputModel.beforeTransformTxt = String(sum)
                    if sum > 107 {
                        inputModel.afterTransformTxt = "大"
                    }else if sum < 107 {
                        inputModel.afterTransformTxt = "小"
                    }else{
                        inputModel.afterTransformTxt = "和"
                    }
                }
                
            }
            
        }
        bigSmallItemModel.cellFillClosure = {(outputModel:LFRoadOutputParamModel, cell: LFRoadChartCollectionViewCell) in
            if "大" == outputModel.showTxt {
                cell.bgColor = kRoadRedColor
            }else if "小" == outputModel.showTxt {
                cell.bgColor = kRoadBlueColor
            }else{
                cell.bgColor = kRoadGreenColor
            }
            
        }
        categoryModel.itemList.append(bigSmallItemModel)
        
        let singleDoubleItemModel = LFAskRoadItemModel()
        singleDoubleItemModel.title = "单双"
        singleDoubleItemModel.askTitles = ["单","双"]
        singleDoubleItemModel.isShowBottomThreeRoad = true
        singleDoubleItemModel.transformClosure = {(inputModel:LFRoadInputParamModel, obj: AnyObject) in
            if let objDict = obj as? [String : Any] {
                let numsTxt: String = objDict["nums"] as? String ?? ""
                if numsTxt.isEmpty {
                    inputModel.isWaitOpen = true
                }else{
                    inputModel.isWaitOpen = false
                    let nums: [String] = numsTxt.components(separatedBy: ",")
                    var sum: Int = 0
                    for oneNum in nums {
                        sum = sum + Int(oneNum)!
                    }
                    inputModel.beforeTransformTxt = String(sum)
                    if sum == 107 {
                        inputModel.afterTransformTxt = "和"
                    }else if sum % 2 == 0 {
                        inputModel.afterTransformTxt = "双"
                    }else{
                        inputModel.afterTransformTxt = "单"
                    }
                }
                
            }
            
        }
        singleDoubleItemModel.cellFillClosure = {(outputModel:LFRoadOutputParamModel, cell: LFRoadChartCollectionViewCell) in
            if "双" == outputModel.showTxt {
                cell.bgColor = kRoadRedColor
            }else if "单" == outputModel.showTxt {
                cell.bgColor = kRoadBlueColor
            }else{
                cell.bgColor = kRoadGreenColor
            }
            
        }
        categoryModel.itemList.append(singleDoubleItemModel)
        
        self.categoryList.append(categoryModel)
        
        let list = ["红球一","红球二","红球三","红球四","红球五","红球六","蓝球一"]
        for i in 0..<list.count {
            let title = list[i]
            let categoryModel = LFAskRoadCategoryModel()
            categoryModel.title = title
            
            let numItemModel = LFAskRoadItemModel()
            numItemModel.title = "球号"
            numItemModel.isShowBottomThreeRoad = false
            numItemModel.transformClosure = {(inputModel:LFRoadInputParamModel, obj: AnyObject) in
                if let objDict = obj as? [String : Any] {
                    let numsTxt: String = objDict["nums"] as? String ?? ""
                    if numsTxt.isEmpty {
                        inputModel.isWaitOpen = true
                    }else{
                        inputModel.isWaitOpen = false
                        let nums: [String] = numsTxt.components(separatedBy: ",")
                        let oneNumTxt: String = nums[i]
                        inputModel.beforeTransformTxt = oneNumTxt
                        inputModel.afterTransformTxt = oneNumTxt
                    }
                    
                }
                
            }
            numItemModel.cellFillClosure = {(outputModel:LFRoadOutputParamModel, cell: LFRoadChartCollectionViewCell) in
                let oneNum: Int = Int(outputModel.showTxt) ?? 0
                if oneNum > 8 {
                    cell.bgColor = kRoadRedColor
                }else if 8 < oneNum {
                    cell.bgColor = kRoadBlueColor
                }else{
                    cell.bgColor = kRoadGreenColor
                }
                
            }
            numItemModel.isShowBigRoadTxt = true
            numItemModel.isShowBottomThreeRoad = false
            categoryModel.itemList.append(numItemModel)
            
            let bigSmallItemModel = LFAskRoadItemModel()
            bigSmallItemModel.title = "大小"
            bigSmallItemModel.askTitles = ["大","小"]
            bigSmallItemModel.isShowBottomThreeRoad = true
            bigSmallItemModel.transformClosure = {(inputModel:LFRoadInputParamModel, obj: AnyObject) in
                if let objDict = obj as? [String : Any] {
                    let numsTxt: String = objDict["nums"] as? String ?? ""
                    if numsTxt.isEmpty {
                        inputModel.isWaitOpen = true
                    }else{
                        inputModel.isWaitOpen = false
                        let nums: [String] = numsTxt.components(separatedBy: ",")
                        let lastNumTxt: String = nums[i]
                        let lastNum: Int = Int(lastNumTxt) ?? 0
                        inputModel.beforeTransformTxt = lastNumTxt
                        if lastNum > 8 {
                            inputModel.afterTransformTxt = "大"
                        }else if lastNum < 8 {
                            inputModel.afterTransformTxt = "小"
                        }else{
                            inputModel.afterTransformTxt = "和"
                        }
                    }
                    
                }
                
            }
            bigSmallItemModel.cellFillClosure = {(outputModel:LFRoadOutputParamModel, cell: LFRoadChartCollectionViewCell) in
                if "大" == outputModel.showTxt {
                    cell.bgColor = kRoadRedColor
                }else if "小" == outputModel.showTxt {
                    cell.bgColor = kRoadBlueColor
                }else{
                    cell.bgColor = kRoadGreenColor
                }
                
            }
            categoryModel.itemList.append(bigSmallItemModel)
            
            let singleDoubleItemModel = LFAskRoadItemModel()
            singleDoubleItemModel.title = "单双"
            singleDoubleItemModel.askTitles = ["单","双"]
            singleDoubleItemModel.isShowBottomThreeRoad = true
            singleDoubleItemModel.transformClosure = {(inputModel:LFRoadInputParamModel, obj: AnyObject) in
                if let objDict = obj as? [String : Any] {
                    let numsTxt: String = objDict["nums"] as? String ?? ""
                    if numsTxt.isEmpty {
                        inputModel.isWaitOpen = true
                    }else{
                        inputModel.isWaitOpen = false
                        let nums: [String] = numsTxt.components(separatedBy: ",")
                        let lastNumTxt: String = nums[i]
                        let lastNum: Int = Int(lastNumTxt) ?? 0
                        inputModel.beforeTransformTxt = lastNumTxt
                        if lastNum == 8 {
                            inputModel.afterTransformTxt = "和"
                        }else if lastNum % 2 == 0 {
                            inputModel.afterTransformTxt = "双"
                        }else{
                            inputModel.afterTransformTxt = "单"
                        }
                    }
                    
                }
                
            }
            singleDoubleItemModel.cellFillClosure = {(outputModel:LFRoadOutputParamModel, cell: LFRoadChartCollectionViewCell) in
                if "双" == outputModel.showTxt {
                    cell.bgColor = kRoadRedColor
                }else if "单" == outputModel.showTxt {
                    cell.bgColor = kRoadBlueColor
                }else{
                    cell.bgColor = kRoadGreenColor
                }
                
            }
            categoryModel.itemList.append(singleDoubleItemModel)
            
            self.categoryList.append(categoryModel)
        }
    }


}
