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

class LFNumTrendViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    var mapClosure: MapTrendInputBlock? {
        didSet(newValue){
            self.calculateDatas()
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
        scrollView.backgroundColor = UIColor.green
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
        self.tableView.snp.makeConstraints { (make) in
            make.top.left.equalTo(0)
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
    func calculateDatas() -> Void {
        if self.dataList.count == 0 || self.mapClosure == nil {
            return
        }
        if let inputList = self.mapClosure?(self.dataList) {
            LFTrendCalculate.calculateOmiAndStatictis(inputList: inputList, colList: self.colList) { (omiList: [LFTrendOutputOmiRowModel], statisticsList: [LFTrendOutputStatisticsItemModel]) in
                //print(omiList,statisticsList)
                self.omiList = omiList
                self.statisticsList = statisticsList
                DispatchQueue.global().asyncAfter(deadline: .now()+2, execute: {
                    DispatchQueue.main.async {
                       // self.activityIndicatorView.stopAnimating()
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                    }
                })
                
            }
        }
    }
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
    

    // MARK: - UITableViewDataSource,UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = Bundle.main.loadNibNamed("LFNumTrendIssuseTableViewCell", owner: nil, options: nil)?.last as! LFNumTrendIssuseTableViewCell
        header.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        header.backgroundColor = UIColor.white
        header.issuseLbl.textColor = UIColor.lightGray
        header.issuseLbl.text = "期号"
        return header
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: CGFloat.leastNormalMagnitude))
        return footer
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
        return cell
    }
}
