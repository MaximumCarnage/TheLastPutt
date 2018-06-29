//
//  LevelSelectController.swift
//  TheLastPutt
//
//  Created by Dylan Bruton on 2018-06-29.
//  Copyright © 2018 Dean,Dylan,JP,Mark. All rights reserved.
//

import UIKit


class LevelSelectController: UIViewController {
    var levelSelect: String = " "
    
    @IBAction func SetLevel(_ sender: UIButton) {
        levelSelect = sender.currentTitle!
        performSegue(withIdentifier: "levelToGame", sender: self)
       
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GameViewController{
            let vc = segue.destination as? GameViewController
            vc?.level = levelSelect
        }
    }
    
}


