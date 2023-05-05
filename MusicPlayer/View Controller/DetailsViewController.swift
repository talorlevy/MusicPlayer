//
//  SongViewController.swift
//  MusicPlayer
//
//  Created by Talor Levy on 3/24/23.
//

import UIKit
import AVFoundation


class DetailsViewController: UIViewController {


    // MARK: - @IBOutlet

    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var songSlider: UISlider!
    @IBOutlet weak var pausePlayButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    var result: ResultModel?

    var audioPlayer: AVPlayer?
    var timer: Timer?
    var isPlaying = false


    // MARK: - override

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadSongInformation()
        configureAudio()
        configureTimer()
    }


    // MARK: - functions

    func configureUI() {
        trackLabel.font = Styling.emphasize
        artistLabel.font = UIFont.systemFont(ofSize: 18)
        releaseDateLabel.font = UIFont.systemFont(ofSize: 15)
        releaseDateLabel.textColor = .gray
        priceLabel.font = UIFont.systemFont(ofSize: 15)
        priceLabel.textColor = .gray
    }

    func loadSongInformation() {
        if let result = result, let releaseDate = result.releaseDate,
           let price = result.trackPrice {
            trackLabel.text = result.trackName
            artistLabel.text = result.artistName
            releaseDateLabel.text = "Release date: \(Formatting.formatDate(dateString: releaseDate) ?? "")" 
            priceLabel.text = Formatting.priceToString(price: price)
        }
        if let url = URL(string: result?.artworkUrl100 ?? "") {
            ImageProvider.shared.fetchImage(url: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.songImageView.image = image ?? UIImage(named: "no_image")
                }
            }
        } else {
            songImageView.image = UIImage(named: "no_image")
        }
    }

    func configureAudio() {
        if let url = URL(string: result?.previewUrl ?? "") {
            let playerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer(playerItem: playerItem)
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        }
    }

    func configureTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let audioPlayer = self.audioPlayer else { return }
            let currentTime = CMTimeGetSeconds(audioPlayer.currentTime())
            let duration = CMTimeGetSeconds(audioPlayer.currentItem?.duration ?? CMTime.zero)
            let sliderValue = Float(currentTime / duration)
            self.songSlider.value = sliderValue.isNaN ? 0 : sliderValue
        }
    }

    @objc func playerDidFinishPlaying() {
        stopButtonAction(self)
        pausePlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isPlaying = false
    }


    // MARK: - @IBAction

    @IBAction func pausePlayButtonAction(_ sender: Any) {
        if let audioPlayer = audioPlayer {
            if isPlaying {
                audioPlayer.pause()
                pausePlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            } else {
                audioPlayer.play()
                pausePlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            }
            isPlaying = !isPlaying
        }
    }

    @IBAction func stopButtonAction(_ sender: Any) {
        if let audioPlayer = audioPlayer {
            audioPlayer.pause()
            audioPlayer.seek(to: CMTime.zero)
            songSlider.value = 0
            pausePlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isPlaying = false
        }
    }

    @IBAction func songSliderAction(_ sender: UISlider) {
        if let audioPlayer = audioPlayer {
            let duration = CMTimeGetSeconds(audioPlayer.currentItem?.duration ?? CMTime.zero)
            let seekTime = CMTimeMakeWithSeconds(Float64(sender.value) * duration, preferredTimescale: 1000)
            audioPlayer.seek(to: seekTime)
        }
    }
}
