//
//  TokenModel.swift
//  DeplisPrueba
//
//  Created by Maximiliano Ovando Ramirez on 07/11/22.
//

import Foundation

struct Token: Codable {
    let success: Bool
    let expiresAt, requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
