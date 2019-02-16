//
//  LFColdHotViewController.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 31/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class LFColdHotViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print((#file).components(separatedBy: "/").last!,#function)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
