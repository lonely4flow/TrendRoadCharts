//
//  LFAskRoadCategoryModel.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFAskRoadItemModel: NSObject
{
    var title: String?
    var isShowBottomThreeRoad: Bool = true
    var askTitles:[String]?
    var transformClosure: LFRoadTransformInputModelClosure?
    var cellFillClosure: LFRoadChartFillCellClosure?
}
class LFAskRoadCategoryModel: NSObject {
    var title: String?
    var itemList:[LFAskRoadItemModel] = []
}
