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
    
    var loadContext: GetUsersontext?
    var model: UsersModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContext = GetUsersontext()
        
        if let context = loadContext {
            context.execute{ (context, success) in
                if success {
                    self.model = context.usersModel
                    self.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource Extension

extension UsersViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = self.model {
            return model.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        
        if let model = self.model {
            cell.fillWithModel(model[indexPath.row])
        }
        
        return cell
    }
    
}