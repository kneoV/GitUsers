//
//  GetUsersContext.swift
//  GitUsers
//
//  Created by Vitaliy Voronok on 6/16/16.
//  Copyright © 2016 Vitaliy Voronok. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetUsersontext {
    var usersModel: UsersModel?
    
    func execute(completionHandler: (context: GetUsersontext, success: Bool) -> Void) {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            Alamofire.request(.GET, "https://api.github.com/users", parameters: ["per_page":100])
                .responseJSON { response in
                    
                    if let data = response.result.value {
                        let json = JSON(data)
                        
                        var users = UsersModel()
                        
                        for item in json.arrayValue {
                            let id = item["id"].intValue
                            let login = item["login"].stringValue
                            let avatarLink = item["avatar_url"].stringValue
                            let profileLink = item["html_url"].stringValue
                            
                            let user = UserModel(userID: id, login: login, profileLink: profileLink, avatarLink: avatarLink)
                            
                            users.addUser(user)
                        }
                        
                        self.usersModel = users
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHandler(context:self, success: true)
                    }
            }
            
        }
        
    }
}