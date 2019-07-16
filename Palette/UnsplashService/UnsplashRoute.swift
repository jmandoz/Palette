//
//  UnsplashRoute.swift
//  Palette
//
//  Created by DevMountain on 4/2/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

enum UnsplashRoute {
    
    static let baseUrl = "https://api.unsplash.com/"
    //TODO: - Input Unsplash Client Id
    static let clientId = "6f43ffe0f2f85a43297cc440a2ee91714537978b2b5dd6a57a2d05803a4cbc45"
    
    case random
    case featured
    case doubleRainbow
    
    var path: String {
        switch self {
        case .random:
            return "/photos/random"
        case .featured:
            return "/photos/"
        case .doubleRainbow:
            return "/search/photos"
        }
    }
    
    var queryItems: [URLQueryItem] {
        var items = [
            URLQueryItem(name: "client_id", value: UnsplashRoute.clientId),
            URLQueryItem(name: "count", value: "10")
        ]
        switch self {
        case .random, .featured:
            return items
        case .doubleRainbow:
            items.append(URLQueryItem(name: "query", value: "double rainbow"))
            return items
        }
    }
    
    var fullUrl: URL? {
        guard let url = URL(string: UnsplashRoute.baseUrl)?.appendingPathComponent(path) else { return nil }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queryItems
        return components?.url
    }
}
