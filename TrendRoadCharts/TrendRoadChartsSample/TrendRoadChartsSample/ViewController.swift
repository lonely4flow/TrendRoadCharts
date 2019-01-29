//
//  ViewController.swift
//  TrendRoadChartsSample
//
//  Created by 娜娜子 on 29/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var webview: UIWebView!
    @IBOutlet weak var tableView: UITableView!
    var dataList: [[String: Any]] = [[String: Any]]()
    var maxIssuse = 153
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview.delegate = self
        self.title = "2018全年双色球开奖结果"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "问路图", style: .done, target: self, action: #selector(showRoadCharts))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "走势图", style: .done, target: self, action: #selector(showTrendCharts))
        
        
        
        let defaults = UserDefaults.standard
        if let dataList = defaults.object(forKey: "dataList") {
            self.dataList = dataList as! [[String : Any]]
            self.tableView.reloadData()
        }else{
            self.requestWebData()
        }
       
        
    }
    // MARK: 展示问路图
    @objc func showRoadCharts()
    {
        
    }
    // MARK: 展示走势图
    @objc func showTrendCharts()
    {
        
    }
    func requestWebData(){
        // 2018 总153期
        if self.maxIssuse <= 0
        {
            let defaults = UserDefaults.standard
            defaults.set(self.dataList, forKey: "dataList")
            defaults.synchronize()
            self.tableView.reloadData()
          return
        }
        let urlString = String(format: "http://www.17500.cn/ssq/details.php?issue=2018%03ld", self.maxIssuse)
        self.webview.loadRequest(URLRequest(url: URL(string:urlString)!))
        self.maxIssuse = self.maxIssuse - 1
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - UITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell  = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        
        let data = self.dataList[indexPath.row]
        cell?.textLabel?.text = data["index"] as? String
        cell?.detailTextLabel?.text = data["nums"] as? String
        return cell!
    }
    // MARK: - UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true;
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let htmlTxt = webView.stringByEvaluatingJavaScript(from: "document.getElementsByTagName('center')[1].innerHTML") {
            var dict = [String:Any]()
            //开奖期数
            if let issuseRange = htmlTxt.range(of:"“双色球”第") {
                var issuse = htmlTxt.suffix(from: issuseRange.lowerBound)
                issuse = issuse.prefix("“双色球”第2019012".count)
                issuse = issuse.suffix("2019012".count)
                dict["index"] = issuse
            }
            // 开奖号
            if let numsRange = htmlTxt.range(of:"出球顺序：") {
                var nums = htmlTxt.suffix(from: numsRange.lowerBound)
                nums = nums.prefix("出球顺序：15 05 18 13 26 09 + 05".count)
                nums = nums.suffix("15 05 18 13 26 09 + 05".count)
                let tempNums = nums.replacingOccurrences(of: " + ", with: " ").components(separatedBy: " ").joined(separator: ",")
                nums = tempNums.prefix(tempNums.count)
                dict["nums"] = nums
            }
            self.dataList.append(dict)
            self .requestWebData()
        }
        
        
    }
}

