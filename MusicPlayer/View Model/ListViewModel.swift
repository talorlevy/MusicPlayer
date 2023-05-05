//
//  MusicListViewModel.swift
//  MusicPlayer
//
//  Created by Talor Levy on 3/25/23.
//

import Foundation


class ListViewModel {
    
    var results: [ResultModel] = []
    
    func fetchResults(completion: @escaping() -> Void) {
        NetworkManager.shared.fetchData(urlString: Constants.urls.jsonDocumentUrl.rawValue) { [weak self] (result: Result<JSONModel, Error>) in
            switch result {
            case .success(let jsonDoc):
                self?.results = jsonDoc.results
                completion()
            case .failure(let error):
                print("Error fetching results: \(error.localizedDescription)")
            }
        }
    }
}
