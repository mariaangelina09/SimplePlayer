//
//  MusicViewController.swift
//  SimplePlayer
//
//  Created by Maria Angelina on 29/01/22.
//

import AVKit
import UIKit

class MusicViewController: UIViewController {
    // MARK: - @IBOutlet(s)
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var songProgressView: UIProgressView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!
    
    // MARK: - Variable(s)
    var player: AVPlayer?
    var songs: [Song] = []
    var currentSong: Song?
    var currentIndex: IndexPath?
    var timer: Timer?
    var indexProgress = 0
    var previewDuration = 30
    var isPlaying = false
    
    // MARK: - Override Function(s)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupUI()
    }
    
    // MARK: - Function(s)
    private func setupUI() {
        searchView.layer.borderWidth = 1
        searchView.layer.borderColor = UIColor.lightGray.cgColor
        
        playPauseButton.tintColor = .mainColor
        forwardButton.tintColor = .mainColor
        backwardButton.tintColor = .mainColor
    }
    
    private func setupTableView() {
        songTableView.delegate = self
        songTableView.dataSource = self
        songTableView.register(SongTableViewCell.self)
        songTableView.register(EmptyStateTableViewCell.self)
    }
    
    private func searchSong(artistName: String = "", limit: Int?) {
        updateCell(hide: true)
        stopSong()
        
        MusicService.shared.searchSongs(artistName: artistName, limit: limit, completionHandler: { [weak self] songItems in
            self?.songs = songItems
            
            DispatchQueue.main.async {
                self?.songTableView.reloadData()
            }
        })
    }
    
    private func setPlayPauseImage() {
        let imageButton = isPlaying ? "pause.circle.fill" : "play.circle.fill"
        playPauseButton.setImage(UIImage(systemName: imageButton), for: .normal)
    }
    
    private func playSong() {
        let musicUrl  = URL.init(string: currentSong?.previewUrl ?? "")
        
        guard let url = musicUrl else {
            debugPrint("DEBUGGED PRINT: --Music Url is not valid")
            return
        }
        
        isPlaying = true
        
        setupPlayer()
        pauseSong()
        reinitProgress()
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setupProgress), userInfo: nil, repeats: true)
        player?.play()
    }
    
    private func pauseSong() {
        timer?.invalidate()
        player?.pause()
    }
    
    func stopSong() {
        pauseSong()
        reinitProgress()
        resetPlayingSong()
        
        animatePlayer(hidden: true)
    }
    
    private func reinitProgress() {
        songProgressView.progress = 0.0
        indexProgress = 0
    }
    
    private func resetPlayingSong() {
        isPlaying = false
        currentSong = nil
        currentIndex = nil
    }
    
    @objc private func setupProgress() {
        guard indexProgress <= previewDuration else {
            updateCell(hide: true)
            stopSong()
            return
        }
        
        songProgressView.progress = Float(indexProgress) / Float(previewDuration)
        indexProgress += 1
    }
    
    private func setupPlayer() {
        trackNameLabel.text = currentSong?.trackName
        artistNameLabel.text = currentSong?.artistName
        
        MusicService.shared.loadImageData(urlString: currentSong?.artworkUrl100 ?? "", completionHandler: { [weak self] image in
            DispatchQueue.main.async {
                self?.artworkImageView.image = image
            }
        })
        
        setPlayPauseImage()
        animatePlayer(hidden: false)
    }
    
    private func animatePlayer(hidden: Bool) {
        UIView.transition(with: playerView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.playerView.isHidden = hidden
        })
    }
    
    // MARK: - @IBAction(s)
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        if isPlaying {
            pauseSong()
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setupProgress), userInfo: nil, repeats: true)
            player?.play()
        }
        
        isPlaying = !isPlaying
        
        updateCell(hide: !isPlaying)
        setPlayPauseImage()
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        // TODO: - Add Forward Song Function
    }
    
    @IBAction func backwardButtonTapped(_ sender: Any) {
        // TODO: - Add Backward Song Function
    }
}

// MARK: - UITableViewDelegate
extension MusicViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return songs.isEmpty ? 280 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentIndex != nil {
            updateCell(hide: true)
        }
        
        currentSong = songs[indexPath.row]
        currentIndex = indexPath
        
        updateCell(hide: false)
        playSong()
    }
}

// MARK: - UITableViewDataSource
extension MusicViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.isEmpty ? 1 : songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if songs.isEmpty {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as EmptyStateTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SongTableViewCell
            cell.setupData(song: songs[indexPath.row])
            return cell
        }
    }
    
    func updateCell(hide: Bool) {
        guard let index = currentIndex, let cell = songTableView.cellForRow(at: index) as? SongTableViewCell else { return }
        cell.loadImageGif(hide: hide)
    }
}

// MARK: - UITextFieldDelegate
extension MusicViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                return false
            } else if string == "\n" {
                if let searchText = textField.text {
                    searchSong(artistName: searchText, limit: nil)
                }
                
                textField.resignFirstResponder()
                return false
            }
        }
        catch {
            debugPrint("DEBUGGED PRINT: --Regex failed")
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            searchSong(artistName: searchText, limit: nil)
        }
        
        textField.resignFirstResponder()
        return false
    }
}
