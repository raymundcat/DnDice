//
//  Springable+CustomAnimations.swift
//  DnDice
//
//  Created by John Raymund Catahay on 07/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation
import Spring

extension Springable{
    
    func excitedPop(){
        self.animation = "pop"
        self.duration = 2
        self.force = 2
        self.curve = "easeInOut"
        self.rotate = 3
        self.animate()
    }
    
    func pop(){
        self.animation = "pop"
        self.duration = 1.5
        self.force = 2
        self.curve = "easeInOut"
        self.animate()
    }
    
    func fall(completion: (() -> ())?){
        self.animation = "fall"
        self.curve = "easeIn"
        self.duration = 0.5
        self.animateNext { 
            completion?()
        }
    }
    
    func mildShake(){
        self.animation = "pop"
        self.duration = 1.5
        self.force = 0.5
        self.animate()
    }
    
    func shake(completion: (() -> ())?){
        self.animation = "swing"
        self.duration = 0.5
        self.animate()
        self.animation = "wobble"
        self.duration = 0.5
        self.force = 0.8
        self.animateToNext {
            completion?()
        }
    }
    
    func extraShake(){
        self.shake {
            self.shake(completion: nil)
        }
    }
    
    func wobble(completion: (() -> ())?) {
        self.animation = "pop"
        self.curve = "easeIn"
        self.duration = 0.5
        self.animate()
        self.animation = "swing"
        self.curve = "easeIn"
        self.duration = 0.5
        self.animateToNext {
            completion?()
        }
    }
}
