//
//  UsersModel.swift
//  GitUsers
//
//  Created by Vitaliy Voronok on 6/16/16.
//  Copyright © 2016 Vitaliy Voronok. All rights reserved.
//

import Foundation

struct UsersModel {
    private var mutableUsers: Array<UserModel>
    
    var users: Array<UserModel> {
        get { return mutableUsers }
    }
    
    mutating func addUser(user: UserModel)  {
        mutableUsers.append(user)
    }
    
    mutating func addUsers(users: Array<UserModel>)  {
        mutableUsers.appendContentsOf(users)
    }
    
    mutating func removeUser(user: UserModel) {
        mutableUsers.removeObject(user)
    }
    
    init() {
        mutableUsers = [UserModel]()
    }
}

// MARK: - CollectionType Extension

extension UsersModel: CollectionType {
    var startIndex: Int { return mutableUsers.startIndex }
    var endIndex: Int { return mutableUsers.endIndex }
    
    subscript(idx: Int) -> UserModel {
        guard idx < endIndex else {
            fatalError("Index out of bounds")
        }
        
        return mutableUsers[idx]
    }
    
    func generate() -> UsersGenerator {
        return UsersGenerator(users: mutableUsers)
    }
}

// MARK: - ArrayLiteralConvertible Extension

extension UsersModel: ArrayLiteralConvertible {
    init(arrayLiteral elements: UserModel...) {
        self.mutableUsers = elements
    }
}

// MARK: - RangeReplaceableCollectionType Extension

extension UsersModel: RangeReplaceableCollectionType {
    mutating func reserveCapacity(n: Int) {
        return mutableUsers.reserveCapacity(n)
    }
    
    mutating func replaceRange<C : CollectionType where C.Generator.Element == UserModel>(subRange: Range<Int>, with newElements: C) {
        mutableUsers.replaceRange(subRange, with: newElements)
    }
}

// MARK: - RangeReplaceableCollectionType Extension

struct UsersGenerator: GeneratorType {
    private var users: Array<UserModel>
    private var nextIndex: Int
    
    init(users: Array<UserModel>) {
        self.users = users
        
        nextIndex = users.startIndex
    }
    
    mutating func next() -> UserModel? {
        if nextIndex >= users.endIndex {
            return nil
        }
        
        let user = users[nextIndex]
        nextIndex += 1
        
        return user
    }
}
