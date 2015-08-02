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
        static let HOUR_COMPLETED_MSG = "Done!"
        static let PRESS_PLAY_MSG = "PRESS PLAY LET'S GO!!"
        static let ALERT_SOUND = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("airhorn", ofType: "mp3")!)
    }
    
    let player = MPMusicPlayerController.systemMusicPlayer()
    
    var isPlaying: Bool! = false
    var notStarted: Bool! = true
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
        if(notStarted == true) {
            shotLabel.text = String(counterShot++)
            timeTimer = NSTimer.scheduledTimerWithTimeInterval(PowerTracksConstants.UPDATE_TIME_INTERVAL, target:self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
            shotTimer = NSTimer.scheduledTimerWithTimeInterval(PowerTracksConstants.NEXT_SONG_INTERVAL, target:self,
                selector: Selector("nextSong"), userInfo: nil, repeats: true)
            notStarted = !notStarted;
            startTime = NSDate.timeIntervalSinceReferenceDate()
            nextButton.enabled = true
            nextButton.alpha = 1.0
        }
        
        if (!isPlaying) {
            player.play()
            songLabel.text = player.nowPlayingItem.title
            artistLabel.text = player.nowPlayingItem.artist
            albumLabel.text = player.nowPlayingItem.albumTitle
            
            if (player.nowPlayingItem.artwork != nil) {
                albumArt.image = player.nowPlayingItem.artwork.imageWithSize(CGSize(width: PowerTracksConstants.WIDTH,
                    height: PowerTracksConstants.HEIGHT))
            } else {
                albumArt.image = UIImage(contentsOfFile: "notAvailable")
            }
            
            isPlaying = true
            playButton.setTitle("Pause", forState: .Normal)
        } else {
            player.pause()
            isPlaying = false
            playButton.setTitle("Play", forState: .Normal)
        }
        
        //isPlaying = !isPlaying
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
        } else {
            albumArt.image = UIImage(contentsOfFile: "notAvailable")
        }
        
        isPlaying = true
        playButton.setTitle("Pause", forState: .Normal)
    }
    
    @IBAction func Restart(sender: AnyObject) {
        // Restart hour logic here
        counterTime = 0
        counterShot = 1
        notStarted = true
        isPlaying = false
        playButton.setTitle("Play", forState: .Normal)
        
        songLabel.text = PowerTracksConstants.PRESS_PLAY_MSG
        nextButton.enabled = false
        nextButton.alpha = 0.5
        artistLabel.text = ""
        albumLabel.text = ""
        
        player.stop()
        timeTimer.invalidate()
        shotTimer.invalidate()
        timeLabel.text = "-"
        shotLabel.text = "0"
    }
    
    func nextSong() {
        // Check if hour is complete
        if (counterShot == PowerTracksConstants.END_HOUR) {
            // Hour has been completed
            //messageLabel.text = PowerTracksConstants.HOUR_COMPLETED_MSG
            player.stop()
            timeTimer.invalidate()
            timeLabel.text = PowerTracksConstants.HOUR_COMPLETED_MSG
            return;
        }
        
        // Play alert sound
        /*AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        var error: NSError?
        var audioPlayer = AVAudioPlayer()
        audioPlayer = AVAudioPlayer(contentsOfURL: alertSound, error: nil)
        audioPlayer.prepareToPlay()
        audioPlayer.play()*/
        
        // Skip to next song
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
        } else {
            albumArt.image = UIImage(contentsOfFile: "notAvailable")
        }
        
        isPlaying = true
        playButton.setTitle("Pause", forState: .Normal)
    }
    
    func updateTimer() {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let milliseconds = UInt8(elapsedTime * 100)
        
        let strSeconds = String(format: "%02d", seconds)
        let strMilliseconds = String(format: "%02d", milliseconds)
        
        timeLabel.text = "\(strSeconds):\(strMilliseconds)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = PowerTracksConstants.BUTTON_CORNER
        playButton.setTitle("Play", forState: .Normal)
        nextButton.enabled = false
        nextButton.alpha = 0.5
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

