//
//  UserModel.swift
//  GitUsers
//
//  Created by Vitaliy Voronok on 6/16/16.
//  Copyright © 2016 Vitaliy Voronok. All rights reserved.
//

import Foundation

struct UserModel {
    let userID: Int
    let login: String
    let profileLink: String
    let avatarLink: String
}

extension UserModel: Equatable {}

func ==(lhs: UserModel, rhs: UserModel) -> Bool {
    return lhs.userID == rhs.userID 
}