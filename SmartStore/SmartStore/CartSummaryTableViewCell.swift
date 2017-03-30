//
//  CartSummaryTableViewCell.swift
//  SmartStore
//
//  Created by Ramesh Chandran A on 19/03/17.
//  Copyright © 2017 smartapps. All rights reserved.
//

import UIKit

class CartSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
