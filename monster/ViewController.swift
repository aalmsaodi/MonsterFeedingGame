//
//  ViewController.swift
//  monster
//
//  Created by user on 7/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImage: MonsterImg!
    @IBOutlet weak var foodImage: DragImage!
    @IBOutlet weak var heartImage: DragImage!

    
    @IBOutlet weak var pelantyImage1: UIImageView!
    @IBOutlet weak var pelantyImage2: UIImageView!
    @IBOutlet weak var pelantyImage3: UIImageView!
    
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var livespanel: UIImageView!
    
    @IBOutlet weak var selectBlueMonster: UIButton!
    @IBOutlet weak var selectGrayMonster: UIButton!
    
    @IBOutlet weak var firstWindowLabel: UILabel!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    let BLUE_MONSTER = 1
    let GRAY_MONSTER = 0
    var monster = 0; //BLUE_MONSTER or GRAY_MONSTER
    
    var currentPenalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do{
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxBite.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }

    }

    @IBAction func onBluePressed(sender: AnyObject) {
        monster = BLUE_MONSTER
        startGame()
    }
    
    @IBAction func onGrayPressed(sender: AnyObject) {
        monster = GRAY_MONSTER
        startGame()
    }
    
    @IBAction func onRestartPressed(sender: AnyObject) {
        pelantyImage1.alpha = DIM_ALPHA
        pelantyImage2.alpha = DIM_ALPHA
        pelantyImage3.alpha = DIM_ALPHA
        
        currentPenalties = 0
        
        restartButton.hidden = true
        startGame()
    }
    
    func startGame(){
        monsterImage.hidden = false
        pelantyImage1.hidden = false
        pelantyImage2.hidden = false
        pelantyImage3.hidden = false
        pelantyImage1.alpha = DIM_ALPHA
        pelantyImage2.alpha = DIM_ALPHA
        pelantyImage3.alpha = DIM_ALPHA
        livespanel.hidden = false
        foodImage.hidden = false
        heartImage.hidden = false
        selectBlueMonster.hidden = true
        selectGrayMonster.hidden = true
        firstWindowLabel.hidden = true
        
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage

        monsterImage.playIdleAnimation(monster)        
        monsterFeedingType()
        
        startTimer()
    }
    
    func startTimer(){
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState(){
        if monsterHappy == false {
            currentPenalties++
            sfxSkull.play()
            
            if currentPenalties == 1 {
                pelantyImage1.alpha = OPAQUE
            } else if currentPenalties == 2 {
                pelantyImage2.alpha = OPAQUE
            } else if currentPenalties >= 3 {
                pelantyImage3.alpha = OPAQUE
            } else {
                pelantyImage1.alpha = DIM_ALPHA
                pelantyImage2.alpha = DIM_ALPHA
                pelantyImage3.alpha = DIM_ALPHA
            }
            
            if currentPenalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        monsterFeedingType()
        monsterHappy = false
    }
    
    func itemDroppedOnCharacter(notif: AnyObject){
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALPHA
        foodImage.userInteractionEnabled = false
        heartImage.alpha = DIM_ALPHA
        heartImage.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func monsterFeedingType(){
        let rand = arc4random_uniform(2) //0 or 1
        
        if rand == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.userInteractionEnabled = false
            
            heartImage.alpha = OPAQUE
            heartImage.userInteractionEnabled = true
        } else {
            heartImage.alpha = DIM_ALPHA
            heartImage.userInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.userInteractionEnabled = true
        }
        currentItem = rand
    }
    
    func gameOver(){
        timer.invalidate()
        monsterImage.deathAnimation(monster)
        
        sfxDeath.play()
        restartButton.hidden = false
    }
    

}

