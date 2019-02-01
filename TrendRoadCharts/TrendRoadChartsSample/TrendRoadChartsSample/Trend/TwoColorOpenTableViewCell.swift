//
//  TwoColorOpenTableViewCell.swift
//  TrendRoadChartsSample
//
//  Created by LonelyFlow on 31/01/2019.
//  Copyright © 2019 Lonely traveller. All rights reserved.
//

import UIKit

class TwoColorOpenTableViewCell: UITableViewCell {

    @IBOutlet weak var issuseLbl: UILabel!
    @IBOutlet weak var redLbl: UILabel!
    @IBOutlet weak var blueLbl: UILabel!
    @IBOutlet weak var waitOpenLbl: UILabel!
    
    @IBOutlet var lines: [UIView]!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
