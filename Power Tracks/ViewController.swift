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
    
    struct PowerTracksConstants {
        static let WIDTH = 320
        static let HEIGHT = 294
        static let BUTTON_CORNER = CGFloat(10.0)
        static let END_HOUR = 61
        static let NEXT_SONG_INTERVAL = NSTimeInterval(60)
        static let UPDATE_TIME_INTERVAL = NSTimeInterval(0.01)
        static let HOUR_COMPLETED_MSG = "Power Hour Completed!"
    }
    
    let player = MPMusicPlayerController.systemMusicPlayer()

    var isPlaying: Bool! = false
    var beginHour: Bool! = true
    var timeTimer = NSTimer()
    var shotTimer = NSTimer()
    var counterTime = 0
    var counterShot = 1
    var albumArtwork: UIImage!
    var startTime = NSTimeInterval()
    
    @IBOutlet var albumArt: UIImageView!
    
    @IBOutlet var messageLabel: UILabel!
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
            timeTimer = NSTimer.scheduledTimerWithTimeInterval(PowerTracksConstants.UPDATE_TIME_INTERVAL, target:self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
            shotTimer = NSTimer.scheduledTimerWithTimeInterval(PowerTracksConstants.NEXT_SONG_INTERVAL, target:self,
                selector: Selector("nextSong"), userInfo: nil, repeats: true)
            beginHour = !beginHour;
        }
        
        if (!isPlaying) {
            player.play()
            startTime = NSDate.timeIntervalSinceReferenceDate()
            songLabel.text = player.nowPlayingItem.title
            artistLabel.text = player.nowPlayingItem.artist
            albumLabel.text = player.nowPlayingItem.albumTitle
            if (player.nowPlayingItem.artwork != nil) {
                albumArt.image = player.nowPlayingItem.artwork.imageWithSize(CGSize(width: PowerTracksConstants.WIDTH,
                    height: PowerTracksConstants.HEIGHT))
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
            albumArt.image = player.nowPlayingItem.artwork.imageWithSize(CGSize(width: PowerTracksConstants.WIDTH,
                height: PowerTracksConstants.HEIGHT))
        }
    }
    
    
    @IBAction func Restart(sender: AnyObject) {
        // Restart hour logic here
    }
    
    func nextSong() {
        if (counterShot == PowerTracksConstants.END_HOUR) {
            // Hour has been completed
            //messageLabel.text = PowerTracksConstants.HOUR_COMPLETED_MSG
            player.stop()
            timeTimer.invalidate()
            timeLabel.text = "Done!"
            return;
        }
        
        player.skipToNextItem()
        player.play()
        startTime = NSDate.timeIntervalSinceReferenceDate()
        shotLabel.text = String(counterShot++)
        songLabel.text = player.nowPlayingItem.title
        artistLabel.text = player.nowPlayingItem.artist
        albumLabel.text = player.nowPlayingItem.albumTitle
        if (player.nowPlayingItem.artwork != nil) {
            albumArt.image = player.nowPlayingItem.artwork.imageWithSize(CGSize(width: PowerTracksConstants.WIDTH,
                height: PowerTracksConstants.HEIGHT))
        }
    }
    
    func updateTimer() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = (currentTime - startTime)+1
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let milliseconds = UInt8(elapsedTime * 100)
        
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        timeLabel.text = "\(strSeconds):\(strMilliseconds)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = PowerTracksConstants.BUTTON_CORNER
        nextButton.layer.cornerRadius = PowerTracksConstants.BUTTON_CORNER
        restartButton.layer.cornerRadius = PowerTracksConstants.BUTTON_CORNER
        
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

