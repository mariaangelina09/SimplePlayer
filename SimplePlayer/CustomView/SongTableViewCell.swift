//
//  SongTableViewCell.swift
//  SimplePlayer
//
//  Created by Maria Angelina on 29/01/22.
//

import UIKit

class SongTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    // MARK: - @IBOutlet(s)
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var equalizerImageView: UIImageView!
    
    // MARK: - Override Function(s)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Function(s)
    private func setupUI() {
        selectionStyle = .none
        equalizerImageView.isHidden = true
    }
    
    func setupData(song: Song) {
        trackNameLabel.text = song.trackName
        artistNameLabel.text = song.artistName
        albumLabel.text = song.collectionName
        equalizerImageView.loadGif(name: "icSound")
        
        MusicService.shared.loadImageData(urlString: song.artworkUrl100 ?? "", completionHandler: { [weak self] image in
            DispatchQueue.main.async {
                self?.artworkImageView.image = image
            }
        })
    }
    
    func loadImageGif(hide: Bool) {
        equalizerImageView.isHidden = hide
    }
}
