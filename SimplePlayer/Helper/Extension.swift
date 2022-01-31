//
//  Extension.swift
//  SimplePlayer
//
//  Created by Maria Angelina on 29/01/22.
//

import Foundation

// MARK: - URL Extension(s)
extension URL {
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        
        return urlComponents.url
    }
}
