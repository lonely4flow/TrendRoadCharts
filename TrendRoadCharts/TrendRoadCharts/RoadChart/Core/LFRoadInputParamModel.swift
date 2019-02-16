//
//  LFRoadInputParamModel.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 15/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFRoadInputParamModel: NSObject {
    var isWaitOpen: Bool = false /*是否属于等待开奖，等待开奖的会忽略不参与计算*/
    var isAskRoad: Bool = false /*用于在展示问路时展示用，不参与计算*/
    var beforeTransformTxt: String? /*用于携带方便查看和UI展示使用，不参与计算*/
    var afterTransformTxt: String! /*用于大路是否要换行或换列的判断*/
    var originData: Any? /*携带的参数，用于方便UI展示或debug查看，不参与计算*/
    
}
