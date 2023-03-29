//
//  MusicInfoViewController.swift
//  Music App
//
//  Created by Дархан Есенкул on 28.03.2023.
//

import UIKit
import AVFoundation

class MusicInfoViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    
    public var song = MusicResponseModel(artistName: "", trackName: "", previewUrl: "", artworkUrl30: "", artworkUrl60: "", artworkUrl100: "")
    
    var player:AVPlayer?
    var playerItem: AVPlayerItem?
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var songPoster:UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    var timeObserverToken: Any?
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: song.previewUrl)
        trackName.text = song.trackName
        artistName.text = song.artistName
        setImage(imageUrl: song.artworkUrl100)
        songPoster.layer.cornerRadius = 30
        songPoster.clipsToBounds = true
        playerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
    }
    deinit {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
    }
    
    func setImage(imageUrl: String){
        guard let url = URL(string: imageUrl) else{return}
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if error == nil{
                if let imageData = data{
                    DispatchQueue.main.async {
                        self.songPoster.image = UIImage(data: imageData)
                    }
                }
            }
            else{
                print("Error: \(error!.localizedDescription)")
            }
        }
        task.resume()
    }
    
    @IBAction func playButtonDidTap(_ sender: UIButton) {
        if isPlaying {
            player?.pause()
            sender.setImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        } else {
            player?.play()
            sender.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
        }
        isPlaying = !isPlaying
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let time = CMTimeMakeWithSeconds(Float64(sender.value), preferredTimescale: 1)
        player?.seek(to: time)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            guard let statusNumber = change?[.newKey] as? NSNumber else { return }
            let status = AVPlayerItem.Status(rawValue: statusNumber.intValue)
            if status == .readyToPlay {
                let duration = CMTimeGetSeconds(playerItem!.duration)
                slider.maximumValue = Float(duration)
                let interval = CMTimeMake(value: 1, timescale: 10)
                timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] time in
                    guard let self = self else { return }
                    let currentTime = CMTimeGetSeconds(time)
                    self.slider.value = Float(currentTime)
                })
                
                player?.play()
                playButton.setImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
                isPlaying = true
            }
        }
    }
    
    
    
    
    
}
