//
//  LFNumTrendViewController.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 30/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit
import SnapKit

// 声明一个闭包类型 MapTrendInputBlock
typealias MapTrendInputBlock = (_ originList:[Any])->([LFTrendInputParamModel])
typealias DrawTrendLineBlock = (_ omiList:[LFTrendOutputOmiRowModel])->(LFTrendDrawLineModel)


class LFNumTrendViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    var mapClosure: MapTrendInputBlock? {
        didSet(newValue){
            self.calculateDatas()
        }
    }
    var drawLineClosures: [DrawTrendLineBlock]?{
        didSet(newValue){
            self.drawLines()
        }
    }
    var dataList: [[String:Any]] = [] {
        didSet(newValue){
            self.calculateDatas()
        }
    }
     var omiList: [LFTrendOutputOmiRowModel] = []
     var statisticsList: [LFTrendOutputStatisticsItemModel] = []
    
    var colList: [String] = [] {
        willSet(newValue){
            if newValue.count>0 {
                let totalWidth = UIScreen.main.bounds.width-100
                var width = totalWidth/CGFloat(newValue.count)
                // 设置最小宽度
                if width < 40 {
                    width = 40
                }
                let height: CGFloat = 40
                self.itemSize = CGSize(width: width, height: height)
            }
        }
        didSet(newValue){
            self.setupCollectionHeaderData()
            self.layout.colCount = self.colList.count
            self.layout.itemSize = self.itemSize
        }
    }
    var itemSize: CGSize = CGSize.zero
    lazy var layout = {()->LFTrendNumLayout in
        let layout = LFTrendNumLayout()
        return layout
    }()
    // 懒加载左侧期号tableView
    lazy var tableView = {()->UITableView in
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.register(UINib(nibName: "LFNumTrendIssuseTableViewCell", bundle: nil), forCellReuseIdentifier: "LFNumTrendIssuseTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.red
        return tableView
        
    }()
    // 懒加载右侧上面部分标题
    lazy var collectionHeaderView = {()-> UIScrollView in
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.white
        return scrollView
    }()
    // 懒加载右侧collectionView
    lazy var collectionView = {()-> UICollectionView in
        self.layout.colCount = self.colList.count
        self.layout.itemSize = self.itemSize
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(LFTrendNumItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.blue
        return collectionView
    }()
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        let tableHeaderLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        tableHeaderLbl.textAlignment = NSTextAlignment.center
        tableHeaderLbl.font = UIFont.systemFont(ofSize: 14)
        tableHeaderLbl.text = "期号"
        tableHeaderLbl.textColor = UIColor.lightGray
        tableHeaderLbl.backgroundColor = UIColor.white
        self.view.addSubview(tableHeaderLbl)
        self.tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(40)
            make.bottom.equalTo(-100)
            make.width.equalTo(100)
        }
        self.view.addSubview(self.collectionHeaderView)
        self.collectionHeaderView.snp.makeConstraints { (make) in
            make.top.right.equalTo(0)
            make.left.equalTo(self.tableView.snp.right)
            make.height.equalTo(40)
        }
        self.view.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.bottom.equalTo(-100)
            make.left.equalTo(self.tableView.snp.right)
            make.top.equalTo(self.collectionHeaderView.snp.bottom)
        }
        let verticalLine = UIView(frame: CGRect.zero)
        verticalLine.backgroundColor = UIColor.lightGray
        self.view.addSubview(verticalLine)
        verticalLine.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(self.tableView.snp.right)
            //make.right.equalTo(self.collectionView.snp.left)
            make.width.equalTo(0.5)
            make.bottom.equalTo(self.tableView.snp.bottom)
        }
        print((#file).components(separatedBy: "/").last!,#function)
    }
    func setupCollectionHeaderData() -> Void{
        for colIndex in 0..<self.colList.count {
            let x = CGFloat(colIndex)*self.itemSize.width
            let y: CGFloat = 0
            let lbl = UILabel(frame: CGRect(x: x, y: y, width: self.itemSize.width, height: self.itemSize.height))
            lbl.text = self.colList[colIndex]
            lbl.textAlignment = NSTextAlignment.center
            lbl.textColor = UIColor.lightGray
            self.collectionHeaderView.addSubview(lbl)
            
            let leftLine = UIView(frame: CGRect(x: x, y: 0, width: 0.5, height: self.itemSize.height))
            leftLine.backgroundColor = UIColor.lightGray
            self.collectionHeaderView.addSubview(leftLine)
        }
        self.collectionHeaderView.contentSize.width = CGFloat(self.colList.count) * self.itemSize.width
    }
    // MARK: - 计算遗漏及统计数据
    func calculateDatas() -> Void {
        if self.dataList.count == 0 || self.mapClosure == nil {
            return
        }
        if let inputList = self.mapClosure?(self.dataList) {
            LFTrendCalculate.calculateOmiAndStatictis(inputList: inputList, colList: self.colList) { (omiList: [LFTrendOutputOmiRowModel], statisticsList: [LFTrendOutputStatisticsItemModel]) in
                self.omiList = omiList
                self.statisticsList = statisticsList
                DispatchQueue.global().asyncAfter(deadline: .now()+2, execute: {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                        self.drawLines()
                    }
                })
                
            }
        }
    }
    // MARK: - 计算位置并画线
    func drawLines() -> Void {
        
        if self.omiList.count == 0 {
            // 没有数据不做计算
            return
        }
        if self.drawLineClosures == nil {
            return
        }
        // 对数据的frame进行计算
        self.calculateItemFrame()
        // 对旧的线进行删除
        self.clearOldLines()
        // 开始划线
        for i in 0..<self.drawLineClosures!.count {
            let lineClosure = self.drawLineClosures![i]
            let lineModel = lineClosure(self.omiList)
            
            // 半径
            let radius: CGFloat = (min(self.itemSize.width,self.itemSize.height) - 4)/2
            for index in 0..<(lineModel.frameList.count-1) {
                // 当前行中奖的model
                let currentRowFrameModel = lineModel.frameList[index] as! LFOmiItemFrameModel
                // 下一行中奖的model
                let nextRowFrameModel = lineModel.frameList[index+1] as! LFOmiItemFrameModel
                // 两个中心点水平方向之间的距离
                let disWidth = abs(currentRowFrameModel.center.x - nextRowFrameModel.center.x)
                // 两个中心点竖直方向之间的距离
                let disHeight = abs(nextRowFrameModel.center.y - currentRowFrameModel.center.y)
                // 两个点之间的距离，直角三角形的斜边长度计算 x²+y²=z²
                let dis: CGFloat = sqrt(pow(disWidth,2.0)+pow(disHeight,2.0))
                let rate = radius/dis
                if nextRowFrameModel.center.x <= currentRowFrameModel.center.x {
                    // 下一个节点在当前节点的左侧或正下测
                    // 使用等边三角形进行计算
                    // 下一个节点在当前节点的右侧
                    let x1 = currentRowFrameModel.center.x - rate*disWidth
                    let y1 = currentRowFrameModel.center.y + rate*disHeight
                    
                    let x2 = nextRowFrameModel.center.x + rate*disWidth
                    let y2 = nextRowFrameModel.center.y - rate*disHeight
                    currentRowFrameModel.startPoint = CGPoint(x: x1, y: y1)
                    nextRowFrameModel.endPoint = CGPoint(x: x2, y: y2)
                }else{
                    // 下一个节点在当前节点的右侧
                    let x1 = currentRowFrameModel.center.x + rate*disWidth
                    let y1 = currentRowFrameModel.center.y + rate*disHeight
                    
                    let x2 = nextRowFrameModel.center.x - rate*disWidth
                    let y2 = nextRowFrameModel.center.y - rate*disHeight
                    currentRowFrameModel.startPoint = CGPoint(x: x1, y: y1)
                    nextRowFrameModel.endPoint = CGPoint(x: x2, y: y2)
                }
                
                var startPoint = currentRowFrameModel.startPoint!
                var endPoint = nextRowFrameModel.endPoint!
                // 在数值方向的同一列时，线画的长一些
                if startPoint.x == endPoint.x {
                    startPoint.y = startPoint.y-5
                    endPoint.y = endPoint.y+5
                }
                let bezierPath = UIBezierPath()
                bezierPath.move(to: startPoint)
                bezierPath.addLine(to: endPoint)
                
                let layer = CAShapeLayer()
                layer.path = bezierPath.cgPath
                layer.strokeColor = lineModel.lineColor.cgColor
                layer.fillColor = UIColor.clear.cgColor
                layer.lineWidth = lineModel.lineWith
                layer.lineCap = kCALineJoinRound
                layer.lineJoin = kCALineJoinRound
                layer.name = String(format: "trendLineLayer_%ld", index)
                
                self.collectionView.layer.addSublayer(layer)
            }
        }
        
    }
    // MARK: 计算每个数字的位置
    func calculateItemFrame() -> Void {
        for rowIndex in 0..<self.omiList.count {
            let rowModel = self.omiList[rowIndex]
            // 等待开奖的直接跳过
            if rowModel.isWaitOpen {
                continue
            }
            var frameList: [LFOmiItemFrameModel] = []
            for colIndex in 0..<rowModel.subList.count {
                let omiItemModel = rowModel.subList[colIndex]
                let frameModel = LFOmiItemFrameModel(omiItemModel: omiItemModel)
                
                var x: CGFloat = 0
                var y: CGFloat = 0
                x = CGFloat(colIndex) * self.itemSize.width
                y = CGFloat(rowIndex) * self.itemSize.height
                frameModel.realRect = CGRect(x: x, y: y, width: self.itemSize.width, height: self.itemSize.height)
                frameModel.center = CGPoint(x: x+self.itemSize.width/2, y: y+self.itemSize.height/2)
                frameList.append(frameModel)
            }
            rowModel.subList = frameList
        }
    }
    // MARK: 清空之前的连线
    func clearOldLines() -> Void {
        if self.collectionView.layer.sublayers != nil && self.collectionView.layer.sublayers!.count>0 {
            let count = self.collectionView.layer.sublayers!.count
            for i in 0..<count {
                let subLayer = self.collectionView.layer.sublayers![count-i-1]
                if let layerName = subLayer.name
                {
                    if layerName.hasPrefix("trendLineLayer_") {
                        subLayer.removeFromSuperlayer()
                    }
                }
            }
        }
        
        
    }
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print((#file).components(separatedBy: "/").last!,#function)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print((#file).components(separatedBy: "/").last!,#function)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        if scrollView == self.tableView {
            self.collectionView.contentOffset.y = offset.y
        } else if scrollView == self.collectionView {
            self.tableView.contentOffset.y = offset.y
            self.collectionHeaderView.contentOffset.x = offset.x
        } else if scrollView == self.collectionHeaderView {
            self.collectionView.contentOffset.x = offset.x
        }
    }
    // MARK: - UITableViewDataSource,UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.omiList.count > 0 {
            // 遗漏+4行统计
            return self.omiList.count+4
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFNumTrendIssuseTableViewCell", for: indexPath) as! LFNumTrendIssuseTableViewCell
        if  indexPath.row < self.omiList.count {
            // 遗漏+4行统计
            let rowModel = self.omiList[indexPath.row]
            let data = rowModel.orginObj as! [String:Any]
            cell.issuseLbl.text = (data["index"] as! String)+"期"
            cell.issuseLbl.textColor = UIColor.lightGray
        }else{
            let index = indexPath.row-self.omiList.count
            switch index {
            case 0:
                cell.issuseLbl.text = "出现次数"
                cell.issuseLbl.textColor = UIColor.red
            case 1:
                cell.issuseLbl.text = "平均遗漏"
                cell.issuseLbl.textColor = UIColor.green
            case 2:
                cell.issuseLbl.text = "最大遗漏"
                cell.issuseLbl.textColor = UIColor.blue
            case 3:
                cell.issuseLbl.text = "最大连出"
                cell.issuseLbl.textColor = UIColor.purple
            default:
                // do something
                print("do something")
            }
        }
        
        
        cell.selectionStyle = .none
        return cell
    }
    // MARK: - UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if self.omiList.count > 0 {
            // 遗漏+4行统计
            return self.omiList.count+4
        }else{
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < self.omiList.count {
            // 遗漏部分
            let rowModel = self.omiList[section]
            if rowModel.isWaitOpen {
                // 等待开奖的只显示一个”等待开奖“
                return 1
            }else{
                // 显示列头的数量
                return self.colList.count
            }
        }else{
            // 统计部分
            // 显示列头的数量
            return self.colList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LFTrendNumItemCollectionViewCell
        
        if indexPath.section < self.omiList.count {
            // 遗漏部分
            let rowModel = self.omiList[indexPath.section]
            if rowModel.isWaitOpen {
                // 等待开奖的只显示一个”等待开奖“
                cell.showTxt = "等待开奖"
                cell.awardCount = 0
                cell.awardStyle = .none(txtColor: UIColor.lightGray)
            }else{
                // 内容
                let itemModel = rowModel.subList[indexPath.item]
                cell.showTxt = itemModel.showTxt
                cell.awardCount = itemModel.awardCount
                if itemModel.isAward {
                    cell.awardStyle = .circle(bgColor: UIColor.brown, txtColor: UIColor.green)
                    if self.colList.count == 4 {
                        cell.awardStyle = .radiusRound(bgColor: UIColor.orange, txtColor: UIColor.purple, radius: 5)
                    }
                }else{
                    cell.awardStyle = .none(txtColor: UIColor.lightGray)
                }
            }
        }else{
            // 统计部分
            // 显示列头的数量
            let index = indexPath.section-self.omiList.count
            let itemModel = self.statisticsList[indexPath.item]
            switch index {
            case 0:
                // 出现次数
                cell.awardStyle = .none(txtColor: UIColor.red)
                cell.showTxt = String(format: "%ld", itemModel.awardCount)
            case 1:
                // 平均遗漏
                cell.awardStyle = .none(txtColor: UIColor.green)
                cell.showTxt = String(format: "%ld", itemModel.avgOmiCount)
                
            case 2:
                // 最大遗漏
                cell.awardStyle = .none(txtColor: UIColor.blue)
                cell.showTxt = String(format: "%ld", itemModel.maxOmiCount)
                
            case 3:
                // 最大连出
                cell.awardStyle = .none(txtColor: UIColor.purple)
                cell.showTxt = String(format: "%ld", itemModel.maxContinueCount)
            default:
                // do something
                print("do something")
            }
            cell.awardCount = 0
        }
        cell.backgroundColor = UIColor.white
        cell.setNeedsDisplay()
        return cell
    }
}
