//
//  MainMenuController.swift
//  TheLastPutt
//
//  Created by Mark Parsikhian on 2018-07-05.
//  Copyright © 2018 Dean,Dylan,JP,Mark. All rights reserved.
//

import UIKit
import AVFoundation



class MainMenuController: UIViewController {
    
    var musicEffect: AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let musicFile = Bundle.main.path(forResource: "MenuMusic", ofType: ".mp3")
        do {
            try musicEffect = AVAudioPlayer (contentsOf: URL (fileURLWithPath: musicFile!))
            
            musicEffect.play()
        }
        catch {
            print(error)
        }
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        musicEffect.stop()
    }
    

}
