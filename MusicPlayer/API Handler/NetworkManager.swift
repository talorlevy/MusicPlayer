//
//  NetworkManager.swift
//  MusicPlayer
//
//  Created by Talor Levy on 3/24/23.
//

import Foundation


class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Decodable>(urlString: String, completion: @escaping(Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let errorReceived = error {
                completion(.failure(errorReceived))
            } else {
                guard let receivedData = data else { return }
                do {
                    let receivedModel = try JSONDecoder().decode(T.self, from: receivedData)
                    completion(.success(receivedModel))
                }
                catch (let error) {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

