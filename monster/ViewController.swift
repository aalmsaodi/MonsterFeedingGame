//
//  ViewController.swift
//  monster
//
//  Created by user on 7/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import UIKit
import AVFoundation

var currentItem = 0

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
    let HEART = 0
    let FOOD = 1
    let BLUE_MONSTER = 1
    let GRAY_MONSTER = 0
    var monster = 0; //BLUE_MONSTER or GRAY_MONSTER
    
    var currentPenalties = 0
    var timer: Timer!
    var monsterHappy = false
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(_:)), name: NSNotification.Name(rawValue: "onTargetDropped"), object: nil)
        
        do{
            try musicPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "skull", ofType: "wav")!))
            
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

    @IBAction func onBluePressed(_ sender: AnyObject) {
        monster = BLUE_MONSTER
        startGame()
    }
    
    @IBAction func onGrayPressed(_ sender: AnyObject) {
        monster = GRAY_MONSTER
        startGame()
    }
    
    @IBAction func onRestartPressed(_ sender: AnyObject) {
        pelantyImage1.alpha = DIM_ALPHA
        pelantyImage2.alpha = DIM_ALPHA
        pelantyImage3.alpha = DIM_ALPHA
        
        currentPenalties = 0
        
        restartButton.isHidden = true
        startGame()
    }
    
    func startGame(){
        monsterImage.isHidden = false
        pelantyImage1.isHidden = false
        pelantyImage2.isHidden = false
        pelantyImage3.isHidden = false
        pelantyImage1.alpha = DIM_ALPHA
        pelantyImage2.alpha = DIM_ALPHA
        pelantyImage3.alpha = DIM_ALPHA
        livespanel.isHidden = false
        foodImage.isHidden = false
        heartImage.isHidden = false
        selectBlueMonster.isHidden = true
        selectGrayMonster.isHidden = true
        firstWindowLabel.isHidden = true
        
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
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState(){
        if monsterHappy == false {
            currentPenalties += 1
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
    
    func itemDroppedOnCharacter(_ notif: NSNotification){
        
        let droppedItem = notif.userInfo?["item"] as! Int
        
        if droppedItem == currentItem {
            
            monsterHappy = true
            startTimer()
            
            foodImage.alpha = DIM_ALPHA
            foodImage.isUserInteractionEnabled = false
            heartImage.alpha = DIM_ALPHA
            heartImage.isUserInteractionEnabled = false
            
            if currentItem == HEART {
                sfxHeart.play()
            } else {
                sfxBite.play()
            }
            
        }
    }
    
    func monsterFeedingType(){
        let rand = arc4random_uniform(2) //0 or 1
        
        if rand == 0 {
            foodImage.alpha = DIM_ALPHA
            foodImage.isUserInteractionEnabled = false
            
            heartImage.alpha = OPAQUE
            heartImage.isUserInteractionEnabled = true
        } else {
            heartImage.alpha = DIM_ALPHA
            heartImage.isUserInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.isUserInteractionEnabled = true
        }
        currentItem = Int(rand)
    }
    
    func gameOver(){
        timer.invalidate()
        monsterImage.deathAnimation(monster)
        
        sfxDeath.play()
        restartButton.isHidden = false
    }
    

}

