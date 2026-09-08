//
//  AuthEndpoints.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 07/09/26.
//

import Foundation

nonisolated enum AuthEndpoints {
    static func register(email: String, password: String) throws -> Endpoint {
        struct Register: Encodable {
            let email: String
            let password: String
        }
        
        let body = try Endpoint.jsonBody(Register(email: email, password: password))
        
        return Endpoint(
            path: "users",
            method: .post,
            body: body,
            headers: [APIConfiguration.Header.appToken: APIConfiguration.appTokenValue]
        )
    }
    
    static func login(email: String, password: String) -> Endpoint {
        let credentials = "\(email):\(password)"
        let authorization = Data(credentials.utf8).base64EncodedString()
        return Endpoint(
            path: "users/session/login",
            method: .post,
            headers: [APIConfiguration.Header.authorization: "Basic \(authorization)"]
        )
    }
    
    static func refreshToken(_ refreshToken: String) -> Endpoint {
        Endpoint(
            path: "users/session/access",
            headers: [APIConfiguration.Header.authorization: "Bearer \(refreshToken)"]
        )
    }
    
    static func userInfo(accessToken: String) -> Endpoint {
        Endpoint(path: "users/session/me", headers: [APIConfiguration.Header.authorization: "Bearer \(accessToken)"])
    }
}
