//
//  AuthResponse.swift
//  Spotify
//
//  Created by Khalmatov on 11.09.2023.
//

import Foundation

struct AuthResponse: Codable {
    
    var access_token: String
    var expires_in: Int
    var refresh_token: String
    var scope: String
    var token_type: String
    
}
  
