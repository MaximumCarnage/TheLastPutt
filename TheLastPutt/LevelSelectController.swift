//
//  LevelSelectController.swift
//  TheLastPutt
//
//  Created by Dylan Bruton on 2018-06-29.
//  Copyright © 2018 Dean,Dylan,JP,Mark. All rights reserved.
//

import UIKit
import AVFoundation

var musicEffect: AVAudioPlayer = AVAudioPlayer()




class LevelSelectController: UIViewController {
    var levelSelect: String = " "
    let userDefaults = UserDefaults.standard
    var levelProg = [Bool]()
    var highScores = [Int]()
    var count2: Int = 0
    @IBOutlet var buttonArray: [UIButton]!
    @IBOutlet var scoreLabels: [UILabel]!
    
    
    
    override func viewDidLoad() {
        var count: Int = 0
        let launchedBefore = userDefaults.bool(forKey:"launchedBefore")
        if launchedBefore  {
            levelProg = userDefaults.object(forKey: "levelStatus") as? [Bool] ?? [Bool]()
            highScores = userDefaults.object(forKey: "highScores") as? [Int] ?? [Int]()
        }
        else {
            let levelinit = [true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
            let highScoresInit = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            
            userDefaults.set(levelinit,forKey: "levelStatus")
            userDefaults.set(highScoresInit,forKey: "highScores")
            userDefaults.set(true, forKey: "launchedBefore")
            
            levelProg = userDefaults.object(forKey: "levelStatus") as? [Bool] ?? [Bool]()
            highScores = userDefaults.object(forKey: "highScores") as? [Int] ?? [Int]()
            
            
        }
        
        for item in buttonArray{
            item.isEnabled = levelProg[count]
            count+=1

        }
        let musicFile = Bundle.main.path(forResource: "LevelSelect", ofType: ".mp3")
        do {
            try musicEffect = AVAudioPlayer (contentsOf: URL (fileURLWithPath: musicFile!))
            
            musicEffect.play()
        }
        catch {
            print(error)
        }

        
//        for item in scoreLabels{
//            item.text = "BestScore:" +  String(highScores[count2])
//            count2+=1
//        }

        
    }
    
    @IBAction func SetLevel(_ sender: UIButton) {
        levelSelect = sender.currentTitle!
        performSegue(withIdentifier: "levelToGame", sender: self)
       
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        musicEffect.stop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GameViewController{
            let vc = segue.destination as? GameViewController
            vc?.level = levelSelect
        }
    }
    
}


