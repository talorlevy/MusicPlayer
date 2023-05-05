//
//  UIStackViewExtension.swift
//  MusicPlayer
//
//  Created by Talor Levy on 3/25/23.
//

import UIKit


extension UIStackView {
    
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
    func addResults(results: [ResultModel], targetAction: Selector) {
        for result in results {
            let resultView = UIView()
            resultView.layer.borderWidth = 1
            resultView.layer.borderColor = UIColor.gray.cgColor
            resultView.backgroundColor = .white
            resultView.translatesAutoresizingMaskIntoConstraints = false

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(imageView)

            let titleLabel = UILabel()
            titleLabel.text = result.trackName
            titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .left
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            let artistLabel = UILabel()
            artistLabel.text = result.artistName
            artistLabel.font = UIFont.systemFont(ofSize: 16.0)
            artistLabel.textColor = .darkGray
            artistLabel.numberOfLines = 0
            artistLabel.textAlignment = .left
            artistLabel.translatesAutoresizingMaskIntoConstraints = false

            let labelsStackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
            labelsStackView.axis = .vertical
            labelsStackView.spacing = 15
            labelsStackView.translatesAutoresizingMaskIntoConstraints = false
            resultView.addSubview(labelsStackView)

            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: resultView.leadingAnchor, constant: 30),
                imageView.topAnchor.constraint(equalTo: resultView.topAnchor, constant: 30),
                imageView.bottomAnchor.constraint(equalTo: resultView.bottomAnchor, constant: -30),
                imageView.widthAnchor.constraint(equalToConstant: 100),
                imageView.heightAnchor.constraint(equalToConstant: 100),
                labelsStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 30),
                labelsStackView.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
                labelsStackView.centerYAnchor.constraint(equalTo: resultView.centerYAnchor),
            ])

            if let url = URL(string: result.artworkUrl100 ?? "") {
                ImageProvider.shared.fetchImage(url: url) { image in
                    DispatchQueue.main.async {
                        imageView.image = image ?? UIImage(named: "no_image")
                    }
                }
            } else {
                imageView.image = UIImage(named: "no_image")
            }

            let invisibleButton = UIButton()
            invisibleButton.translatesAutoresizingMaskIntoConstraints = false
            invisibleButton.addTarget(nil, action: targetAction, for: .touchUpInside)
            invisibleButton.tag = results.firstIndex(of: result) ?? 0
            resultView.addSubview(invisibleButton)

            NSLayoutConstraint.activate([
                invisibleButton.leadingAnchor.constraint(equalTo: resultView.leadingAnchor),
                invisibleButton.topAnchor.constraint(equalTo: resultView.topAnchor),
                invisibleButton.trailingAnchor.constraint(equalTo: resultView.trailingAnchor),
                invisibleButton.bottomAnchor.constraint(equalTo: resultView.bottomAnchor),
            ])

            addArrangedSubview(resultView)
        }
    }

}

