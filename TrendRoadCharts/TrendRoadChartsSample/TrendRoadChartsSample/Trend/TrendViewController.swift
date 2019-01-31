//
//  TrendViewController.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 30/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Hue
import SwiftyJSON

class TrendViewController: UIViewController {
    var dataList:[[String:Any]] = []
    var activityIndicatorView: NVActivityIndicatorView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.isTitleViewScrollEnabled = true
        style.isTitleScaleEnabled = true
        // 设置标题内容
        let titlePages = [["title":"开奖",
                           "clazz":"OpenResultViewController"],
                          [
                            "title":"红球走势",
                           "clazz":"LFNumTrendViewController",
                           "colList":Array<Any>.lf_fillNum(from: 1, to: 33, zeroCount: 2),
                           "mapClosure":{(orginList:[Any]) -> [LFTrendInputParamModel] in
                                return orginList.map { (obj :Any) -> LFTrendInputParamModel in
                                    let dict = obj as! [String:Any]
                                    let model = LFTrendInputParamModel()
                                    model.orginObj = dict
                                    let numsTxt: String = dict["nums"] as! String
                                    let nums: [String] =  numsTxt.components(separatedBy: ",")
                                    if nums.count > 0 {
                                        let redTxts: [String] = Array(nums.prefix(6))
                                        model.beforeTransformTxt = redTxts.joined(separator: ",")
                                        model.afterTransformTxts = redTxts
                                        model.isWaitOpen = false
                                    }else{
                                        model.isWaitOpen = true
                                    }
                                    return model
                                }
                            
                            }
                        ],
                      ["title":"篮球走势",
                       "clazz":"LFNumTrendViewController",
                       "colList":Array<Any>.lf_fillNum(from: 1, to: 16, zeroCount: 2),
                       "mapClosure":{(orginList:[Any]) -> [LFTrendInputParamModel] in
                        return orginList.map { (obj :Any) -> LFTrendInputParamModel in
                            let dict = obj as! [String:Any]
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
                        
                        }
                       ],
                      ["title":"篮球大小单双",
                       "clazz":"LFNumTrendViewController",
                       "colList":["大","小","单","双"],
                       "mapClosure":{(orginList:[Any]) -> [LFTrendInputParamModel] in
                        return orginList.map { (obj :Any) -> LFTrendInputParamModel in
                            let dict = obj as! [String:Any]
                            let model = LFTrendInputParamModel()
                            model.orginObj = dict
                            let numsTxt: String = dict["nums"] as! String
                            let nums: [String] =  numsTxt.components(separatedBy: ",")
                            if nums.count > 0 {
                                let blueTxt: String = nums.last!
                                model.beforeTransformTxt = blueTxt
                                let bigSmallTxt = Int(blueTxt)!>=8 ? "大" : "小"
                                let singleDoubleTxt = Int(blueTxt)!%2==0 ? "双" : "单"
                                model.afterTransformTxts = [bigSmallTxt,singleDoubleTxt]
                                model.isWaitOpen = false
                            }else{
                                model.isWaitOpen = true
                            }
                            return model
                        }
                        
                        }
                       ],
                      ["title":"篮球冷热",
                       "clazz":"LFColdHotViewController"],
                      ]
        var titles:[String] = []
        // 创建每一页对应的controller
        let childViewControllers: [UIViewController] = titlePages.map { (dict: [String:Any]) -> UIViewController in
            titles.append(dict["title"]! as! String)
            var className = dict["clazz"] as! String
            className = "TrendRoadChartsSample."+className
            let clazzType = NSClassFromString(className) as! UIViewController.Type
            let vc = clazzType.init()
            vc.view.backgroundColor = UIColor.lf_randomColor()
            if vc.isKind(of: OpenResultViewController.self) {
                (vc as! OpenResultViewController).dataList = self.dataList
            }
            else if vc.isKind(of: LFNumTrendViewController.self) {
                let numVC:LFNumTrendViewController = vc as! LFNumTrendViewController
                numVC.dataList = self.dataList
                numVC.colList = dict["colList"] as! [String]
                if let mapClosure = dict["mapClosure"] as? MapTrendInputBlock {
                    numVC.mapClosure = mapClosure
                }
            }
            return vc
        }
        
        let y = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height ?? 0)
        let size = UIScreen.main.bounds.size
        
        // 创建对应的DNSPageView，并设置它的frame
        let pageView = DNSPageView(frame: CGRect(x: 0, y: y, width: size.width, height: size.height), style: style, titles: titles, childViewControllers: childViewControllers)
        view.addSubview(pageView)
        
        self.activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: (self.view.bounds.width-100)/2, y: (self.view.bounds.height-100)/2, width: 100, height: 100), type: NVActivityIndicatorType.lineScalePulseOutRapid, color: UIColor.purple, padding: 20)
        self.view.addSubview(self.activityIndicatorView)
        self.activityIndicatorView.startAnimating()
        
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
