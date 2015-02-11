//
//  ViewController.swift
//  Udemy18 Music
//
//  Created by Pei Sun on 2015-01-31.
//  Copyright (c) 2015 psun. All rights reserved.
//
//  Plays Music. Allows the user to play, pause, change the volume, and seek to any location in the song.
//  The bottom left button changes itself from "Play" to "Pause" according to the whether the player is playing or paused.

//  Note: If you're running in the simulator, you'll need an mic enabled in your mac system preferences

//  Note to self: Do not constrain the BGimage to view, it'll mess up aspect fit. Please uncheck the box for 'constrain to margins' when making constraints. 
//  Remember to contrain the toolbar too
//  For some reason you can't constrain anything relative to the toolbar, so you have to constrain the BGimage and the bottom slider to the view. To do so, click on the number for the bottom contraint and select 'View (current distance = 0)'.

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var player: AVAudioPlayer = AVAudioPlayer()
    
    // Set up the audioplayer and a timer to update the scrubberSlider
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let audioPath: NSURL = NSBundle.mainBundle().URLForResource("instrumental", withExtension: "mp3")!
        //NOTE: When adding file, make sure to check off 1) Make Copy 2) Create folder references 3)Target
        //println(audioPath) //NOTE: If you have spaces in your project or .mp3 name, there'll be trouble
        
        var error: NSError?  = nil
        
        player = AVAudioPlayer(contentsOfURL: audioPath, error: &error)
        
        player.play()
        player.volume = 0.4
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: Selector("timer"), userInfo: nil, repeats: true)

    }
    
    // Change volume using slider
    // @IBOutlet weak var volumeSlider: UISlider! //Alternative code #1
    @IBAction func volumeChanged(sender: AnyObject) {
        
        let volumeSlider = sender as UISlider // Alternatate code #2 Both works
        player.volume = volumeSlider.value
            //Volume of the built in player takes a value from 0 to 1

    }
    
    // Play or pause the music according to whether the player is playing or paused
    @IBAction func playPausePressed(sender: AnyObject) {
        
        if player.playing {
            player.pause()
        } else {
            player.play()
        }
    }
 
    // Refresh the song from beginning
    @IBAction func refreshPressed(sender: AnyObject) {
        
        // Resets the player so music plays from beginning ----
        player.currentTime = 0
        player.play() //If player is already paused, resetting != play sounds
 
    }
    
    // Change elapsed time of music using scrubberSlider
    @IBOutlet weak var scrubSlider: UISlider!
    @IBAction func scrubChanged(sender: AnyObject) {
        
        player.currentTime = NSTimeInterval(scrubSlider.value) * player.duration
        
    }
    
    // Every 0.02 seconds, 
    // Update the scrubber according to where the player is in the song
    // Calls function to update the bottom left button when necessary
    var leftButtonIsOnPause = true
        //Bottom-left button starts off on "Pause"
    func timer() {
        
        scrubSlider.value =  Float(player.currentTime / player.duration)
        
        if player.playing {
            if leftButtonIsOnPause == false{
                leftButtonIsOnPause = true // Change button to pause
                changeLeftButton()
            }
        } else {
            if leftButtonIsOnPause == true {
                leftButtonIsOnPause = false // Change button to play
                changeLeftButton()
            }
        }
    }
    
    // Updates the bottom left button according whether player is playing or paused
    @IBOutlet weak var toolbar: UIToolbar!
        //IBOutlet allows swap of toolbar buttons (play <-> pause)
    func changeLeftButton(){
        
        var new_button = UIBarButtonItem()
        
        if leftButtonIsOnPause == true {    // Change button to Pause
            
            new_button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "playPausePressed:")
            
        } else {                            // Change button to Play
            
            new_button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: "playPausePressed:")
            
        }
        
        var tb_items = toolbar.items
        tb_items?.removeAtIndex(0)
        tb_items?.insert(new_button, atIndex: 0)
        toolbar.setItems(tb_items, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

