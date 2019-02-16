//
//  LFAskRoadTypeListViewController.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 16/02/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFAskRoadTypeListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    

    lazy var tableView: UITableView = {()->UITableView in
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.red
        return tableView
    }()
    var historyList: [AnyObject]?
    private var dataList: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
        }
        self.dataList = ["大路图和另一列","大路图和另一行","大路图和在非和里面展示"]
        self.tableView.reloadData()
    }
    // MARK: - UITableViewDataSource && UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let txt = self.dataList[indexPath.row]
        cell.textLabel?.text = txt
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel?.text = "detail"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let askRoadVC = LFAskRoad1ViewController()
        self.showAskVC(askRoadVC: askRoadVC)
    }
    
    func showAskVC(askRoadVC: UIViewController) -> Void
    {
        let fromVC = self.navigationController
        fromVC?.definesPresentationContext = true
        
        askRoadVC.view.backgroundColor = UIColor(red: 154/255.0, green: 155/255.0, blue: 157/255.0, alpha: 0.4)
        askRoadVC.modalPresentationStyle = .overCurrentContext
        fromVC?.present(askRoadVC, animated: false, completion: nil)
    }
}
