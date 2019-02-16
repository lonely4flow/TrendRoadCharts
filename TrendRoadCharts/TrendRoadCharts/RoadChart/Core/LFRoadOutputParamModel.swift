//
//  LFRoadOutputParamModel.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 15/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFRoadOutputParamModel: NSObject {
    var inputModel: LFRoadInputParamModel! /*将输入的input携带传递出去，方便UI参数和数据查看，不参与计算*/
    var showTxt: String! /*计算后对应的文字*/
    var heCount: Int = 0 /*当和不单独一行或一列展示，将和与非和数据展示在一格里时连续出现的和的数量*/
}
