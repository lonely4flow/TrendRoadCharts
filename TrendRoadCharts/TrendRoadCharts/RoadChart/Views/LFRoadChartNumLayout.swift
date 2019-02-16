//
//  LFRoadChartNumLayout.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFRoadChartNumLayout: UICollectionViewLayout {
    var rowCount: Int = 6 /*行数*/
    var itemSize: CGSize = CGSize(width: 0, height: 0) /*每个格子的大小*/
    
    private var attributes: [UICollectionViewLayoutAttributes] = []
    private var colCount: Int = 0 /*列数，也就是collectionView的section组数*/
    override func prepare() {
        super.prepare()
        self.attributes = []
        self.colCount = self.collectionView!.numberOfSections
        for colIndex in 0..<self.colCount {
            // 一列里有多少行
            let rowCountOfCol = self.collectionView!.numberOfItems(inSection: colIndex)
            for rowIndex in 0..<rowCountOfCol {
                let indexPath = IndexPath(item: rowIndex, section: colIndex)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let x: CGFloat = CGFloat(colIndex)*self.itemSize.width
                let y: CGFloat = CGFloat(rowIndex)*self.itemSize.height
                attr.frame = CGRect(x: x, y: y, width: self.itemSize.width, height: self.itemSize.height)
                self.attributes.append(attr)
            }
        }
    }
    // 设置内容区域的大小
    override var collectionViewContentSize: CGSize{
        let colCount = self.collectionView!.numberOfSections
        let width = CGFloat(self.colCount) * self.itemSize.width
        let height = CGFloat(colCount) * self.itemSize.height
        return CGSize(width: width, height: height)
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributes
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attrs = super.layoutAttributesForItem(at: indexPath)
        if attrs == nil && indexPath.section == 0 && indexPath.item == 0  {
            attrs = self.attributes.first
        }
        return attrs;
    }
}
