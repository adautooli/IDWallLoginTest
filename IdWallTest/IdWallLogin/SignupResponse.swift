//
//  SignupResponse.swift
//  IdWallLogin
//
//  Created by Adauto Oliveira on 24/04/22.
//

import Foundation

// MARK: - User
struct SignupResponse: Codable {
    let user: UserClass?
}

// MARK: - UserClass
struct UserClass: Codable {
    let id, email, token, createdAt: String?
    let updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case email, token, createdAt, updatedAt
        case v = "__v"
    }
}

