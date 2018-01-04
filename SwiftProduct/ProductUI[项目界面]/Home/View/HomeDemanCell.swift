//
//  HomeDemanCell.swift
//  SwiftProduct
//
//  Created by 恋康科技 on 2017/11/16.
//  Copyright © 2017年 梁元峰. All rights reserved.
//

import UIKit

class HomeDemanCell: UITableViewCell {

    @IBOutlet weak var demanImageView: UIImageView!
    @IBOutlet weak var demanTitlLabel: UILabel!
    @IBOutlet weak var demanContentLabel: UILabel!
    @IBOutlet weak var demanDateLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        demanTitlLabel.font = UIFont.boldSystemFont(ofSize: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
