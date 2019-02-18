//
//  DropListView.swift
//  DropListView
//
//  Created by CIA on 30/11/2017.
//  Copyright © 2017 CIA. All rights reserved.
//

import UIKit

class DropListView: UIView ,UITableViewDelegate,UITableViewDataSource{
    @discardableResult class func showDropListViewWithRelateView(_ relateView:UIView,showingItems:[DropCellConfigure],cellAlignment:DropCellAlignment = .left,cellSeletCallBack:((_ selectIndex:Int)->Void)?,userDismissDropViewCallBack:(()->Void)? = nil) -> DropListView? {
        //findViewCtl
        guard let superView = DropListView.findViewCtlViewForView(relateView) else {
            print("relateView must has ViewController!")
            return nil
        }
        
        var dropView:DropListView! = superView.viewWithTag(637479) as? DropListView
        if dropView == nil{
            dropView = DropListView(frame: superView.bounds)
            dropView?.autoresizingMask = [.flexibleWidth , .flexibleHeight]
            dropView.tag = 637479
            dropView.backgroundColor = UIColor.clear
            superView.addSubview(dropView)
        }
        
        dropView.relateView = relateView
        dropView.cellConfigures = showingItems
        dropView.cellSelectCallBack = cellSeletCallBack
        dropView.userDismissDropViewCallBack = userDismissDropViewCallBack
        dropView.cellAlignment = cellAlignment
        
        dropView.showDropView()
        
        return dropView
    }
    
    //MARK: propertys
    var cellConfigures:[DropCellConfigure] = []
    var cellSelectCallBack:((_ selectIndex:Int)->Void)?
    var userDismissDropViewCallBack:(()->Void)?
    var cellAlignment = DropCellAlignment.left
    weak var relateView:UIView!
    
    //MARK: initialInterFace
    var contentTable = UITableView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTable()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureTable()
    }
    func configureTable() {
        addSubview(contentTable)
        contentTable.dataSource = self
        contentTable.delegate = self
        contentTable.tableFooterView = UIView()
        contentTable.separatorInset = UIEdgeInsets.zero
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfigures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "DropListCellIdentifer"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? DropListCenterTableViewCell
        if cell == nil{
            cell = DropListCenterTableViewCell(identifer: cellID, aliment: cellAlignment)
        }
        cell!.dropCellConfig = cellConfigures[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let selectCompletion = cellSelectCallBack{
            selectCompletion(indexPath.row)
        }
        hideDropView()
    }
    
    
    //MARK:隐藏Table
    func getTableHiddenFrame() -> CGRect {
        let relateViewPoint = relateView.convert(CGPoint.zero, to: superview)
        let frame = CGRect(x: relateViewPoint.x, y: relateViewPoint.y + relateView.frame.size.height, width: relateView.frame.size.width, height: 0)
        return frame
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideDropView()
        
        if let cancelBlock = userDismissDropViewCallBack{
            cancelBlock()
        }
    }
    func hideDropView() {
        UIView.animate(withDuration: 0.4, animations: {
            self.contentTable.frame = self.getTableHiddenFrame()
            self.contentTable.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    
    //MARK:显示Table
    func getTableShowFrame() -> CGRect {
        var totalCellHeight = 0
        for cellConfigre in cellConfigures{
            totalCellHeight += cellConfigre.cellHeight
        }
        
        let relateViewPoint = relateView.convert(CGPoint.zero, to: superview)
        let remainHeight = superview!.bounds.height - (relateViewPoint.y + relateView.frame.size.height)
        let frame = CGRect(x: relateViewPoint.x, y: relateViewPoint.y + relateView.frame.size.height, width: relateView.frame.size.width, height: min(remainHeight - 20, CGFloat(totalCellHeight + 10)))
        return frame
    }
    
    func showDropView()  {
        self.contentTable.frame = getTableHiddenFrame()
        UIView.animate(withDuration: 0.4) {
            self.contentTable.frame = self.getTableShowFrame()
            self.contentTable.alpha = 1
        }
    }
    
    //MARK:内部方法
    private class func findViewCtlViewForView(_ view:UIView)->UIView?{
        var responder = view.next
        while responder != nil {
            if responder is UIViewController{
                return (responder as! UIViewController).view
            }
            responder = responder?.next
        }
        return nil
    }
}
