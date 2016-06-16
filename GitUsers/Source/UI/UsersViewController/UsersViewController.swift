//
//  UsersViewController.swift
//  GitUsers
//
//  Created by Vitaliy Voronok on 6/16/16.
//  Copyright © 2016 Vitaliy Voronok. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverView: UIView!
    
    var loadContext: GetUsersСontext?
    var model = UsersModel()
    var isLoading = false
    var since = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUsers()
    }

    func loadUsers()  {
        if isLoading {
            return
        }
        
        coverView.hidden = false
        isLoading = true
        
        loadContext = GetUsersСontext()
        
        if let context = loadContext {
            context.execute(since) { (context, success) in
                if success {
                    if let usersModel = context.usersModel {
                        self.model.addUsers(usersModel.users)
                        
                        if let lastUser = self.model.last {
                            self.since = lastUser.userID
                        }
                    }
                    
                    self.tableView.reloadData()
                    self.coverView.hidden = true
                    self.loadContext = nil
                    self.isLoading = false
                }
            }
        } else {
            coverView.hidden = true
            isLoading = false
        }
    }

}

// MARK: - UITableViewDataSource Extension

extension UsersViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell

        cell.fillWithModel(model[indexPath.row])

        cell.tapAvatarCompletion = {[unowned self] cell in
            if let viewController: AvatarViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AvatarViewController") as? AvatarViewController {
            
                let model = self.model[indexPath.row]
                viewController.fillWithModel(model)
            
                self.presentViewController(viewController, animated: true, completion: nil)
            }
        }
        
        if indexPath.row == (model.count - 1) {
            self.loadUsers()
        }
        
        return cell
    }
    
}