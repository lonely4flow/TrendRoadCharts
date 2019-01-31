//
//  OpenResultViewController.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 31/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit
import SnapKit

class OpenResultViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var dataList: [[String:Any]] = []
    // 懒加载
    lazy var tableView = {()->UITableView in
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.register(UINib(nibName: "TwoColorOpenTableViewCell", bundle: nil), forCellReuseIdentifier: "TwoColorOpenTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.top.left.right.bottom.equalTo(0)
        }
        
        print((#file).components(separatedBy: "/").last!,#function)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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
        let header = Bundle.main.loadNibNamed("TwoColorOpenTableViewCell", owner: nil, options: nil)?.last as! TwoColorOpenTableViewCell
        header.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 40)
        header.backgroundColor = UIColor.white
        header.waitOpenLbl.isHidden = true
        header.issuseLbl.textColor = UIColor.lightGray
        header.issuseLbl.text = "期号"
        header.redLbl.textColor = UIColor.lightGray
        header.redLbl.text = "红球"
        header.blueLbl.textColor = UIColor.lightGray
        header.blueLbl.text = "篮球"
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
        return self.dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwoColorOpenTableViewCell", for: indexPath) as! TwoColorOpenTableViewCell
        let data = self.dataList[indexPath.row]
        cell.issuseLbl.text = data["index"] as? String
        if let nums: String = data["nums"] as? String {
            cell.waitOpenLbl.isHidden = true
            cell.redLbl.text = String(nums.prefix(nums.count-3))
            cell.blueLbl.text = String(nums.suffix(2))
        }else{
            cell.waitOpenLbl.isHidden = false
        }
        cell.selectionStyle = .none
        return cell
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
