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
    
    @IBAction func SetLevel(_ sender: UIButton) {
        levelSelect = sender.currentTitle!
        performSegue(withIdentifier: "levelToGame", sender: self)
       
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let musicFile = Bundle.main.path(forResource: "LevelSelect", ofType: ".mp3")
        do {
                try musicEffect = AVAudioPlayer (contentsOf: URL (fileURLWithPath: musicFile!))
                
                    musicEffect.play()
                }
        catch {
            print(error)
        }


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GameViewController{
            let vc = segue.destination as? GameViewController
            vc?.level = levelSelect
        }
    }
    
}


