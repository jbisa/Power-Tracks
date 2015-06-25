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
    
    @IBOutlet var albumArt: UIImageView!
    @IBOutlet var shotLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var songTitle: UILabel!
    @IBOutlet var artist: UILabel!
    @IBOutlet var album: UILabel!
    
    @IBAction func PlayPause(sender: AnyObject) {
        if(beginHour == true) {
            shotLabel.text = String(counterShot++)
            //timeTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
            shotTimer = NSTimer.scheduledTimerWithTimeInterval(10, target:self, selector: Selector("nextSong"), userInfo: nil, repeats: true)
            beginHour = !beginHour;
        }
        
        if (!isPlaying) {
            player.play()
        } else {
            player.pause()
        }
        
        isPlaying = !isPlaying
    }
    
    
    @IBAction func Next(sender: AnyObject) {
        player.skipToNextItem()
    }
    
    
    @IBAction func Restart(sender: AnyObject) {
        
    }
    
    func nextSong() {
        player.skipToNextItem()
        shotLabel.text = String(counterShot++)
    }
    
    func updateTimer() {
        timeLabel.text = String(counterTime++)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let mediaItems = MPMediaQuery.songsQuery().items
        let mediaCollection = MPMediaItemCollection(items: mediaItems)
        
        player.setQueueWithItemCollection(mediaCollection)
        //player.indexOfNowPlayingItem
        
        var repItem = mediaCollection.representativeItem
        //var repItem = mediaItems[player.indexOfNowPlayingItem].representativeItem
        var title = repItem.title
        var artistName = repItem.artist
        var albumName = repItem.albumTitle
        var art = repItem.artwork
        
        songTitle.text = title
        artist.text = artistName
        album.text = albumName
        
        //albumArt.image = art
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

