//
//  LTTrendViewController.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 30/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Hue

class LTTrendViewController: UIViewController {
    var dataList:[[String:Any]] = []
    var activityIndicatorView: NVActivityIndicatorView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        
        
        
        
        self.activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: (self.view.bounds.width-100)/2, y: (self.view.bounds.height-100)/2, width: 100, height: 100), type: NVActivityIndicatorType.lineScalePulseOutRapid, color: UIColor.purple, padding: 20)
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.startAnimating()
        
        let inputList = self.dataList.map { (dict :[String:Any]) -> LFTrendInputParamModel in
            let model = LFTrendInputParamModel()
            model.orginObj = dict
            let numsTxt: String = dict["nums"] as! String
            let nums: [String] =  numsTxt.components(separatedBy: ",")
            if nums.count > 0 {
                let blueTxt: String = nums.last!
                model.beforeTransformTxt = blueTxt
                model.afterTransformTxts = [blueTxt]
                model.isWaitOpen = false
            }else{
                model.isWaitOpen = true
            }
            return model
        }
        let colList = Array<Any>.lf_fillNum(from: 1, to: 16,zeroCount: 2)
        LFTrendCalculate.calculateOmiAndStatictis(inputList: inputList, colList: colList) { (omiList: [LFTrendOutputOmiRowModel], statisticsList: [LFTrendOutputStatisticsItemModel]) in
            print(omiList,statisticsList)
            //self.activityIndicatorView.stopAnimating()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
