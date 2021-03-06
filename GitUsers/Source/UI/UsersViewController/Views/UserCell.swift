//
//  UserCell.swift
//  GitUsers
//
//  Created by Vitaliy Voronok on 6/16/16.
//  Copyright © 2016 Vitaliy Voronok. All rights reserved.
//

import UIKit
import AlamofireImage

class UserCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    var tapAvatarCompletion: ((cell: UserCell) -> ())?
    
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
        
        if let URL = NSURL(string: model.avatarLink) {
            avatarImageView.af_setImageWithURL(URL)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        idLabel.text = nil
        loginLabel.text = nil
        linkLabel.text = nil
        
        avatarImageView.image = nil
    }
    
    @IBAction func onTapAvatar(sender: AnyObject) {
        if let completion = tapAvatarCompletion {
            completion(cell: self)
        }
    }
}
