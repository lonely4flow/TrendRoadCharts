//
//  LFRoadChartView.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit
typealias LFRoadChartFillCellClosure = (_ outputModel:LFRoadOutputParamModel,_ cell: LFRoadChartCollectionViewCell)->Void
class LFRoadChartView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate {
    
    

    var itemSize: CGSize = CGSize.zero {
        didSet(newValue){
            let layout = self.collectionViewLayout as! LFRoadChartNumLayout
            layout.itemSize = newValue;
            self.reloadData()
        }
    }
    var cellBgStyle: LFRoadChartCollectionViewCellBgStyle = .solidCircle
    var isShowTxt: Bool = false
    var minShowColCount: Int = 0
    var isShowingAskRoad: Bool = false
    var cellHeCountShowStyle: LFRoadChartCollectionViewCellHeCountShowStyle = .line
    var fillCellClosure: LFRoadChartFillCellClosure?
    var dataList: [[AnyObject]] = [] {
        didSet(newValue){
            self.updateShow()
        }
    }
    func updateShow() -> Void {
        var askRow: Int = -1
        var askCol: Int = -1
        if self.isShowingAskRoad && self.dataList.count > 0
        {
            
            for colIndex in 0..<self.dataList.count {
                var colList = self.dataList[colIndex]
                for rowIndex in 0..<colList.count {
                    let outputModel = colList[rowIndex];
                    if outputModel.isKind(of: LFRoadOutputParamModel.classForCoder()) && (outputModel as! LFRoadOutputParamModel).inputModel.isAskRoad {
                        askRow = rowIndex
                        askCol = colIndex
                        break;
                    }
                }
            }
            if askCol == self.dataList.count-1 && askRow == 0 {
                // 如果正在展示问路，如果问路的那个是最后一列第一行，则不用多一个空白列
            }else{
                // 如果问路的那个不是第一行，则需要添加
                self.dataList.append(Array<AnyObject>.lf_fillObj(count: 6, obj: NSNull()))
            }
        }else{
            self.dataList.append(Array<AnyObject>.lf_fillObj(count: 6, obj: NSNull()))
        }
        self.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            let lastColIndex = self.dataList.count-1;
            var indexPath = IndexPath(item: 0, section: lastColIndex)
            if( askCol >= 0 && askCol <= lastColIndex && askRow >= 0 && askRow <= 5){
                indexPath = IndexPath(item: askRow, section: askCol)
            }
            self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }

    }
    class func initView(frame: CGRect) -> LFRoadChartView
    {
        
        let layout = LFRoadChartNumLayout()
        layout.rowCount = 6
        let chartView = LFRoadChartView(frame: frame, collectionViewLayout: layout)
        chartView.delegate = chartView
        chartView.dataSource = chartView
        chartView.bounces = false
        chartView.showsVerticalScrollIndicator = false
        chartView.showsHorizontalScrollIndicator = false
        chartView.register(LFRoadChartCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        return chartView
    }
    // MARK: - UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
    override var numberOfSections: Int
    {
        return self.dataList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let colList = self.dataList[section]
        return colList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LFRoadChartCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LFRoadChartCollectionViewCell
        cell.backgroundColor = UIColor.clear
        cell.cellItemSize = self.itemSize
        
        let colList = self.dataList[indexPath.section]
        cell.isLastCol = indexPath.section == (self.dataList.count-1)
        cell.isLastRow = indexPath.item == (colList.count-1)
        
        let obj = colList[indexPath.item]
        if obj.isKind(of: NSNull.classForCoder()) {
            cell.showTxt = ""
            cell.bgStyle = .none
            cell.isAskRoadCell = false
            cell.heCount = 0
        }else{
            let model: LFRoadOutputParamModel = obj as! LFRoadOutputParamModel
            cell.bgStyle = self.cellBgStyle
            cell.heCount = model.heCount
            cell.heCountStyle = self.cellHeCountShowStyle
            cell.askAnimColor = self.backgroundColor ?? UIColor.white
            cell.isAskRoadCell = model.inputModel.isAskRoad
            if self.isShowTxt {
                cell.showTxt = model.showTxt
            }else{
                cell.showTxt = ""
            }
            self.fillCellClosure?(model,cell)
        }
        cell.setNeedsDisplay()
        return cell
    }
}
