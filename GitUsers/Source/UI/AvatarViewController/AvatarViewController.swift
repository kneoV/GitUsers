//
//  AvatarViewController.swift
//  GitUsers
//
//  Created by Vitaliy Voronok on 6/16/16.
//  Copyright © 2016 Vitaliy Voronok. All rights reserved.
//

import UIKit
import AlamofireImage

class AvatarViewController: UIViewController {

    var model: UserModel?
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fillWithModel(model: UserModel)  {
        self.model = model
        
        dispatch_async(dispatch_get_main_queue()) {
            if let URL = NSURL(string: model.avatarLink) {
                self.imageView.af_setImageWithURL(URL)
            }
        }
    }
}
