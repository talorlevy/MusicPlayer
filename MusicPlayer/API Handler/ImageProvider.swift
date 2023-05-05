//
//  ImageProvider.swift
//  MusicPlayer
//
//  Created by Talor Levy on 3/25/23.
//

import UIKit


class ImageProvider {
    
    static let shared = ImageProvider()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    public func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            print("Using cache")
            completion(image)
            return
        }
        print("Image not in cache, fetching from download url")
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                guard let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                self?.cache.setObject(image, forKey: url.absoluteString as NSString)
                completion(image)
            }
        }.resume()
    }
}
