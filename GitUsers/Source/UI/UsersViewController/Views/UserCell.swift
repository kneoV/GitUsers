//
//  UserCell.swift
//  GitUsers
//
//  Created by Vitaliy Voronok on 6/16/16.
//  Copyright © 2016 Vitaliy Voronok. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    // MARK: - Initialization and Deallocations
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Public
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fillWithModel(model: UserModel) {
        idLabel.text = String(model.userID)
        loginLabel.text = model.login
        linkLabel.text = model.profileLink
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        idLabel.text = nil
        loginLabel.text = nil
        linkLabel.text = nil
        
        avatarImageView.image = nil
    }
}
