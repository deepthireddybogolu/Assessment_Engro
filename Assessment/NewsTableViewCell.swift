//
//  NewsTableViewCell.swift
//  Assessment
//
//  Created by deepthi reddy on 06/12/22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageview: UIImageView!
    
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
