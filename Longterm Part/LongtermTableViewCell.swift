//
//  LongtermTableViewCell.swift
//  Tic-Tok
//
//  Created by Zhixiang.Zhang on 2018/5/14.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit

class LongtermTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //UI of progress bar is controlled by storyboard
        progress.transform = CGAffineTransform(scaleX: 1.0, y:4.5)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}



