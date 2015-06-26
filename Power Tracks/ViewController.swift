//
//  ViewController.swift
//  Power Tracks
//
//  Created by Jay Bisa on 6/22/15.
//  Copyright (c) 2015 Wovfn. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class ViewController: UIViewController {
    
    let player = MPMusicPlayerController.systemMusicPlayer()

    var isPlaying: Bool! = false
    var beginHour: Bool! = true
    var timeTimer = NSTimer()
    var shotTimer = NSTimer()
    var counterTime = 0
    var counterShot = 1
    var albumArtwork: UIImage!
    
    @IBOutlet var albumArt: UIImageView!
    
    @IBOutlet var shotLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var artistLabel: UILabel!
    @IBOutlet var albumLabel: UILabel!
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var restartButton: UIButton!
    
    @IBAction func PlayPause(sender: AnyObject) {
        if(beginHour == true) {
            shotLabel.text = String(counterShot++)
            //timeTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
            shotTimer = NSTimer.scheduledTimerWithTimeInterval(10, target:self, selector: Selector("nextSong"), userInfo: nil, repeats: true)
            beginHour = !beginHour;
        }
        
        if (!isPlaying) {
            player.play()
            songLabel.text = player.nowPlayingItem.title
            artistLabel.text = player.nowPlayingItem.artist
            albumLabel.text = player.nowPlayingItem.albumTitle
            if (player.nowPlayingItem.artwork != nil) {
                albumArt.image = player.nowPlayingItem.artwork.imageWithSize(CGSize(width: 320, height: 294))
            }
        } else {
            player.pause()
        }
        
        isPlaying = !isPlaying
    }
    
    
    @IBAction func Next(sender: AnyObject) {
        player.skipToNextItem()
        player.play()
        songLabel.text = player.nowPlayingItem.title
        artistLabel.text = player.nowPlayingItem.artist
        albumLabel.text = player.nowPlayingItem.albumTitle
        if (player.nowPlayingItem.artwork != nil) {
            albumArt.image = player.nowPlayingItem.artwork.imageWithSize(CGSize(width: 320, height: 294))
        }
    }
    
    
    @IBAction func Restart(sender: AnyObject) {}
    
    func nextSong() {
        if (counterShot == 61) {
            // Hour has been completed
            shotLabel.text = "Power Hour Completed!"
            player.stop()
            return;
        }
        
        player.skipToNextItem()
        player.play()
        shotLabel.text = String(counterShot++)
        songLabel.text = player.nowPlayingItem.title
        artistLabel.text = player.nowPlayingItem.artist
        albumLabel.text = player.nowPlayingItem.albumTitle
        if (player.nowPlayingItem.artwork != nil) {
            albumArt.image = player.nowPlayingItem.artwork.imageWithSize(CGSize(width: 320, height: 294))
        }
    }
    
    func updateTimer() {
        timeLabel.text = String(counterTime++)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = 10.0
        nextButton.layer.cornerRadius = 10.0
        restartButton.layer.cornerRadius = 10.0
        
        // Do any additional setup after loading the view, typically from a nib.
        let mediaItems = MPMediaQuery.songsQuery().items
        let mediaCollection = MPMediaItemCollection(items: mediaItems)
        
        player.setQueueWithItemCollection(mediaCollection)
        
        // Set the player to shuffle and repeat all songs
        player.shuffleMode = MPMusicShuffleMode.Songs
        player.repeatMode = MPMusicRepeatMode.All
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

