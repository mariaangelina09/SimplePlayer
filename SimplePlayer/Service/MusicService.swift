//
//  MusicService.swift
//  SimplePlayer
//
//  Created by Maria Angelina on 29/01/22.
//

import Foundation
import UIKit

final class JsonDecoder<T: Codable> {
    public class func decode(stringJson: String) -> T? {
        let jsonData = Data(stringJson.utf8)
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: jsonData)
            return decoded
        } catch {
            print("JsonDecoder error: \(error)")
            return nil
        }
    }
}

class MusicService {
    static let shared: MusicService = MusicService()
    
    func searchSongs(artistName: String, limit: Int?, completionHandler: @escaping ([Song]) -> Void) {
        let searchUrl: URL? = URL(string: "\(Constant.Service.baseURL)\(Constant.Path.search)" )
        
        guard let url = searchUrl else {
            debugPrint("DEBUGGED PRINT: --Search Url is not valid")
            return
        }
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "term", value: artistName.lowercased().replacingOccurrences(of: " ", with: "+"))
        ]
        
        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
        }

        guard let newUrl = url.appending(queryItems) else { return }
        
        var request = URLRequest(url: newUrl)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: newUrl) { data, response, error in
            guard let data = data, error == nil else {
                debugPrint("DEBUGGED PRINT: --HTTP Request Failed \(error)")
                return
            }
            
            let dataString = String(data: data, encoding: .utf8)
            let songObject = JsonDecoder<SongObject>.decode(stringJson: dataString ?? "")
            completionHandler(songObject?.results ?? [])
        }

        task.resume()
    }
    
    func loadImageData(urlString: String, completionHandler: @escaping (UIImage) -> Void) {
        let imageUrl: URL? = URL(string: urlString)
        
        guard let url = imageUrl else {
            debugPrint("DEBUGGED PRINT: --Image Url is not valid")
            return
        }
        
        let imageTask = URLSession.shared.dataTask(with: url) { (imageData, imageResponse, imageError) in
            if let imageError = imageError {
                print(imageError)
                return
            }
            
            let image = UIImage(data: imageData!) ?? UIImage(named: "placeholderImage")
            completionHandler(image!)
        }
        imageTask.resume()
    }
}
