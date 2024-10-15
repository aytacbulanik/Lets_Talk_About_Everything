//
//  MessageCell.swift
//  Lets Talk About Everything
//
//  Created by Aytaç Bulanık on 15.10.2024.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var labelView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        labelView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
