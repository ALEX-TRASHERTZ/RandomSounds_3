//
//  ViewControllerDRUMS.swift
//  RandomSounds
//
//  Created by alex on 01/11/17.
//  Copyright © 2017 Alessio Acri. All rights reserved.
//

import UIKit
import AudioKit


class ViewControllerDRUMS: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var beats : AKPeriodicFunction?
        
        let kick = AKSynthKick()
        let snare = AKSynthSnare(duration: 0.07)
        
        let mix = AKMixer(kick, snare)
        
        var counter = 0
        
        beats = AKPeriodicFunction(frequency: 5) {
            let randomVelocity = MIDIVelocity(random(0.0, 127.0))
            let onFirstBeat = counter % 4 == 0
            let everyOtherBeat = counter % 4 == 2
            let randomHit = Array(0...3).randomElement() == 0
            
            if onFirstBeat || randomHit {
                kick.play(noteNumber: MIDINoteNumber(60), velocity: randomVelocity)
                kick.stop(noteNumber: 60)
            }
            if everyOtherBeat {
                let velocity = MIDIVelocity(Array(0...100).randomElement())
                snare.play(noteNumber: 60, velocity: randomVelocity)
                snare.stop(noteNumber: 60)
            }
            counter += 1
        }
        
        //beats?.start() // + drums !
        //AudioKit.start(withPeriodicFunctions: beats!) // + drums !
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}




