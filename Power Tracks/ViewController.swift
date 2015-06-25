//
//  ViewController.swift
//  Power Tracks
//
//  Created by Jay Bisa on 6/22/15.
//  Copyright (c) 2015 Wovfn. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    let player = MPMusicPlayerController.systemMusicPlayer()
    var isPlaying: Bool! = false
    var beginHour: Bool! = true
    var timeTimer = NSTimer()
    var shotTimer = NSTimer()
    var counterTime = 0
    var counterShot = 1
    
    @IBOutlet var albumArt: UIImageView!
    @IBOutlet var ShotLabel: UILabel!
    @IBOutlet var TimeLabel: UILabel!
    @IBOutlet var SongTitle: UILabel!
    @IBOutlet var Artist: UILabel!
    
    @IBAction func PlayPause(sender: AnyObject) {
        if(beginHour == true) {
            ShotLabel.text = String(counterShot++)
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
        //timeTimer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func Restart(sender: AnyObject) {
        
    }
    
    func nextSong() {
        player.skipToNextItem()
        ShotLabel.text = String(counterShot++)
    }
    
    func updateTimer() {
        TimeLabel.text = String(counterTime++)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let mediaItems = MPMediaQuery.songsQuery().items
        let mediaCollection = MPMediaItemCollection(items: mediaItems)
        
        player.setQueueWithItemCollection(mediaCollection)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

