//
//  AuthManager.swift
//  Spotify
//
//  Created by Khalmatov on 10.09.2023.
//

import Foundation

final class AuthManager {
    
    private init() {}
    
    static let shared = AuthManager()
    
    
    struct Constants {
        static let clinetID = "63bac8627e08413b92639ad691d5a47d"
        static let clientSecret = "b5d8a1a516994ddbbdad0f7b0bc3416c"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    }
    
    public var signInUrl: URL? {
        let scope = "user-read-private"
        let Redirect_uri = "https://www.iosacademy.io"
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clinetID)&scope=\(scope)&redirect_uri=\(Redirect_uri)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else {
            return nil
        }
        return accessToken
    }
    
    private var refreshToken: String? {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refresh_token") else {
            return nil
        }
        return refreshToken
    }
    
    private var tokenExperationDate: Date? {
        guard let experationDate = UserDefaults.standard.object(forKey: "experationDate") as? Date else {
             return nil
        }
        return experationDate
    }
    
    var shouldRefreshToken: Bool {
        guard let exprDate = tokenExperationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMin: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMin) >= exprDate
    }
    
    public func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let url =  URL(string: Constants.tokenAPIURL) else {
            return
        }
         var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: "https://www.iosacademy.io")
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clinetID+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let basic64String = data?.base64EncodedString() else {
            print("Failed to get base64 ")
            completion(false)
            return
        }
        request.setValue("Basic \(basic64String)", forHTTPHeaderField: "Authorization")
        
        
         let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do  {
                let result = try  JSONDecoder().decode(AuthResponse.self, from: data)
                self?.casheToken(result: result)
                completion(true)
                
            }
            catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private func refreshAccessToken() {
        
    }
    
    private func casheToken(result: AuthResponse) {
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        UserDefaults.standard.set(result.refresh_token, forKey: "refresh_token")
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "experationDate")
        
    }
    
}


 
