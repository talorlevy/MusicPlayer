//
//  ViewController.swift
//  MusicPlayer
//
//  Created by Talor Levy on 3/24/23.
//

import UIKit


class ListViewController: UIViewController {

    var listViewModel: ListViewModel?
    
    
    // MARK: - @IBOutlet
    
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var musicListStackView: UIStackView!
    
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listViewModel = ListViewModel()
        configureUI()
        fetchResults()
    }
    
    
    // MARK: - functions
    
    func configureUI() {
        musicLabel.font = Styling.title
    }
    
    func loadMusicList(results: [ResultModel]) {
        musicListStackView.addResults(results: results, targetAction: #selector(showResultDetails(_:)))
    }
    
    func fetchResults() {
        listViewModel?.fetchResults {
            DispatchQueue.main.async {
                if let results = self.listViewModel?.results {
                    self.loadMusicList(results: results)
                }
            }
        }
    }
    
    @objc func showResultDetails(_ sender: UIButton) {
        guard let results = listViewModel?.results else { return }
        let selectedResult = results[sender.tag]
        guard let songVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SongViewController") as? DetailsViewController else { return }
        songVC.result = selectedResult
        navigationController?.pushViewController(songVC, animated: true)
    }
}

