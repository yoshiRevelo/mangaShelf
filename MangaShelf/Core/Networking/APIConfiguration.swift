//
//  APIConfiguration.swift
//  MangaShelf
//
//  Created by Josimar Revelo on 16/08/26.
//

import Foundation

nonisolated struct APIConfiguration: Sendable {
    let baseURL: URL
    
    enum Header {
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
        
        //Lo usaremos en para los usuarios
        static let appToken = "App-Token"
    }
    
    static let `default` = APIConfiguration(
        baseURL: URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!
    )
    
    static let appTokenValue = "sLGH38NhEJ0_anlIWwhsz1-LarClEohiAHQqayF0FY"
}
