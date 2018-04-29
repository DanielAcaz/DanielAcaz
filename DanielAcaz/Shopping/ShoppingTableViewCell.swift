//
//  ShoppingTableViewCell.swift
//  DanielAcaz
//
//  Created by Daniel Acaz on 29/04/2018.
//  Copyright © 2018 FIAP. All rights reserved.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {

    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
