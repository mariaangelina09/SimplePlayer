//
//  EmptyStateTableViewCell.swift
//  SimplePlayer
//
//  Created by Maria Angelina on 29/01/22.
//

import UIKit

class EmptyStateTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    // MARK: - Override Function(s)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
