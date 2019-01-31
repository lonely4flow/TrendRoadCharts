//
//  LFTrendNumLayout.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 31/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFTrendNumLayout: UICollectionViewLayout {
    // 列数
    var colCount: Int = 0
    // 每一个栏目的大小
    var itemSize: CGSize = CGSize.zero
    private var attributes: [UICollectionViewLayoutAttributes] = []
    
    override func prepare() {
        super.prepare()
        self.attributes = []
        let sectionCount = self.collectionView!.numberOfSections
        
        for sectionIndex in 0..<sectionCount {
            // 一组里有多少列
            let colCount = self.collectionView!.numberOfItems(inSection: sectionIndex)
            for colIndex in 0..<colCount {
                let indexPath: IndexPath = IndexPath(item: colIndex, section: sectionIndex)
                let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                var x: CGFloat = 0
                var y: CGFloat = 0
                
                // 每个item的宽高
                x = CGFloat(colIndex) * self.itemSize.width
                y = CGFloat(sectionIndex) * self.itemSize.height
                var width: CGFloat = self.itemSize.width;
                if (colCount == 1) {
                    // 只有一行，则该cell展示位满行
                    width = CGFloat(self.colCount)*self.itemSize.width
                }
                attr.frame = CGRect(x: x, y: y, width: width, height: self.itemSize.height)
                self.attributes.append(attr)
                
            }
        }
    }

    override var collectionViewContentSize: CGSize{
        let sectionCount = self.collectionView!.numberOfSections
        let width = CGFloat(self.colCount) * self.itemSize.width
        let height = CGFloat(sectionCount) * self.itemSize.height
        return CGSize(width: width, height: height)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.attributes
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attrs = super.layoutAttributesForItem(at: indexPath)
        if attrs == nil  {
            attrs = self.attributes.first
        }
        return attrs;
    }
}
