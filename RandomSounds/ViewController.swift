//
//  ViewController.swift
//  RandomSounds
//
//  Created by Alessio Acri on 29/07/17.
//  Copyright © 2017 Alessio Acri. All rights reserved.
//

import UIKit
import AudioKit
// http://audiokit.io/docs/

class ViewController: UIViewController, UITextFieldDelegate {

    
    //////////////// CAMPI  //////////////////////////////////////////////////////////////

    @IBOutlet var myButton: UIButton!
    @IBOutlet var myTextField: UITextField!
    @IBOutlet var myTextField2: UITextField!
    @IBOutlet var mySwitch: UISwitch!
    @IBOutlet var mySlider: UISlider!

    var numero1: Double? = 0
    var numero2: Double? = 0
    
    var booleano : Bool = false
    
    var oscillator  : AKOscillator = AKOscillator()
    var oscillator2 : AKOscillator = AKOscillator()
    var oscillator3 : AKOscillator = AKOscillator()
    
    var reverb2 = AKReverb(nil)
    var dist = AKDistortion(nil)
    var delay = AKDelay(nil)
    var filter = AKLowPassFilter(nil)
    var mixer = AKMixer()
    
    
    ///////////////////// METODI //////////////////////////////////////////////////////////
    
    // UTILE PER CAMBIARE NODO LIVE PROVA A GUARDARE http://audiokit.io/playgrounds/Basics/Splitting%20Nodes/
    
    //*************************************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myButton.layer.cornerRadius = 8
        
        myTextField.delegate = self
        myTextField.becomeFirstResponder()
        myTextField.layer.cornerRadius = 5
        
        myTextField2.delegate = self
        myTextField2.becomeFirstResponder()
        myTextField2.layer.cornerRadius = 5
        
        mixer = AKMixer(oscillator, oscillator2, oscillator3)
        //mixer.connect(oscillator3)
        // se lo switch 'Distorsion' è su 
        if booleano == false {
            init1_Reverb_Default()
        }
    }
    //*************************************************************************
    
                    ////////////////////////
    
    //*************************************************************************
    func init1_Reverb_Default() {
        
        AudioKit.disconnectAllInputs()
        
        // creo
        reverb2 = AKReverb(mixer)
        filter = AKLowPassFilter(reverb2)
        delay = AKDelay(filter)
        
        // Setto/Play
        filter.cutoffFrequency = Double(mySlider.value)
        filter.play()
        reverb2.play()
        delay.play()
        
        // Avvio motoreAudio
        AudioKit.output = delay
        AudioKit.start()
        
    }
    //*************************************************************************
    
                    ////////////////////////
    
    //*************************************************************************
    func init2_Distorsion() {
        
        AudioKit.disconnectAllInputs()
        
        // Creo
        dist = AKDistortion(mixer)
        filter = AKLowPassFilter(dist)
        delay = AKDelay(filter)
        
        // Setto/Play
        filter.cutoffFrequency = Double(mySlider.value)
        filter.play()
        
        // Avvio motoreAudio
        AudioKit.output = delay
        AudioKit.start()
    }
    //*************************************************************************
    


    
    ////////////////////////////////////////////////////////////////////////////////////
    //questo è uno dei metodi del delgato del textField
    //serve per intercettare quando l'utente tocca il tasto "invio"
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //leggiamo il contenuto del textField e lo scriviamo nella label
        numero1 = Double(myTextField.text!)
        numero2 = Double(myTextField2.text!)
        
        //chidiamo la tastiera con il metodo resignFirstResponder()
        myTextField.resignFirstResponder()
        myTextField2.resignFirstResponder()
        
        //scriviamo return true perchè questo metodo necessita di un valore di ritorno
        return true
    }
    ////////////////////////////////////////////////////////////////////////////////////

    
                    ////////////////////////
    
    
    ////////////////////////////////////////////////////////////////////////////////////
    //////   P U S H   B U T T O N   ///////////////////////////////////////////////////
    
    @IBAction func toogleSound(_ sender: UIButton) {
        // se l'osc sta suonando, stoppalo!
        if oscillator.isPlaying && oscillator2.isPlaying && oscillator3.isPlaying {
            oscillator.stop()
            oscillator2.stop()
            oscillator3.stop()
            sender.setTitle("Play Sine Wave", for: .normal)
            
            // altrimenti (se non sta suonando)
        } else {
            oscillator.amplitude  = random(in: 0.5...1)
            oscillator.frequency  = random(numero1!, numero2!) //261.626
            oscillator.start()
            oscillator2.amplitude = random(in: 0.5...1)
            oscillator2.frequency = random(numero1!, numero2!)*2  //311.127 //329.628 Major
            oscillator2.start()
            oscillator3.amplitude = random(in: 0.5...1)
            oscillator3.frequency = random(numero1!, numero2!)*3  //391.995
            oscillator3.start()
            sender.setTitle("Stop Sine Wave at \(Int(oscillator.frequency))Hz", for: .normal)
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////

    
                    ////////////////////////

    
    ////////////////////////////////////////////////////////////////////////////////////
    @IBAction func switvhDelay(_ sender: UISwitch) {
        if sender.isOn {
            booleano = false
            init2_Distorsion()
        }else {
            booleano = true
            init1_Reverb_Default()
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////

    
                    ////////////////////////

    
    ////////////////////////////////////////////////////////////////////////////////////
    @IBAction func filterSlider(_ sender: UISlider) {
        filter.cutoffFrequency = Double(mySlider.value)
    }
    ////////////////////////////////////////////////////////////////////////////////////

    
                    ////////////////////////

    
    ////////////////////////////////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    ////////////////////////////////////////////////////////////////////////////////////


}

