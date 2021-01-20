//
//  FactCell.swift
//  Fact-App
//
//  Created by Sumit meena on 20/01/21.
//

import UIKit

class FactCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    public var fact : Fact!{
        didSet{
            self.lblTitle.text = fact.title
            self.lblDescription.text = fact.description
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
