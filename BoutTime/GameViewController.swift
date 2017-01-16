//
//  GameViewController.swift
//  BoutTime
//
//  Created by Roger Rohweder on 1/7/17.
//  Copyright © 2017 Roger Rohweder. All rights reserved.
//

import UIKit
import CoreGraphics

var setsShown: Int = 0
var setsCorrect: Int = 0

class GameViewController: UIViewController {
    @IBOutlet weak var Event1: UITextView!
    @IBOutlet weak var Event2: UITextView!
    @IBOutlet weak var Event3: UITextView!
    @IBOutlet weak var Event4: UITextView!
    @IBOutlet weak var E1FullDown: UIButton!
    @IBOutlet weak var E2HalfUp: UIButton!
    @IBOutlet weak var E2HalfDown: UIButton!
    @IBOutlet weak var E3HalfUp: UIButton!
    @IBOutlet weak var E3HalfDown: UIButton!
    @IBOutlet weak var E4FullUp: UIButton!
    @IBOutlet weak var NextRoundButton: UIButton!
    @IBOutlet weak var TimerDisplay: UILabel!
    
    let instanEvents = Events()
    var gameEvents: [EventData] = []
    var rounds = 0
    var roundsPerGame = 5
    var count = 30
    
    var roundTimer       = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NextRoundButton.isHidden = true
        TimerDisplay.text = "30"
        E1FullDown.tag = 1
        E2HalfUp.tag = 2
        E2HalfDown.tag = 3
        E3HalfUp.tag = 4
        E3HalfDown.tag = 5
        E4FullUp.tag = 6
        do {
        gameEvents = try instanEvents.loadAllEvents(inputFile: "HistoricalEvents", fileType: "plist")
        } catch let error {
            print(error)
        }
        instanEvents.refreshEventSet()
        rounds = 1
        setsShown = 1
        startStopTimer(command: "Start")
        displayEventSetWithoutYear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func checkOrder() {
        displayEventSetWithYear()
        if (instanEvents.eventsInCorrectOrder()) {
            setsCorrect += 1
            NextRoundButton.setImage(UIImage(named: "next_round_success.png"), for: .normal)
        } else {
            NextRoundButton.setImage(UIImage(named: "next_round_fail.png"), for: .normal)
        }
        NextRoundButton.isEnabled = true
        NextRoundButton.isHidden = false
    }
    
    // using info from http://stackoverflow.com/questions/32941319/motionended-method-in-swift-2-0
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake
        {
            startStopTimer(command: "Stop")
        } else {
            print("WRONG ACTION")
        }
    }
  
    @IBAction func swapThese(_ sender: UIButton) {
        
        // set button pushed to selected image
        switch sender.tag {
        case 1:
            sender.setImage(#imageLiteral(resourceName: "down_full_selected.png"), for: .normal)
            instanEvents.swapEvents(swapEvent: 0, withEvent: 1)
        case 2:
            sender.setImage(#imageLiteral(resourceName: "up_half_selected.png"), for: .normal)
            instanEvents.swapEvents(swapEvent: 1, withEvent: 0)
        case 3:
            sender.setImage(#imageLiteral(resourceName: "down_half_selected.png"), for: .normal)
            instanEvents.swapEvents(swapEvent: 1, withEvent: 2)
        case 4:
            sender.setImage(#imageLiteral(resourceName: "up_half_selected.png"), for: .normal)
            instanEvents.swapEvents(swapEvent: 2, withEvent: 1)
        case 5:
            sender.setImage(#imageLiteral(resourceName: "down_half_selected.png"), for: .normal)
            instanEvents.swapEvents(swapEvent: 2, withEvent: 3)
        case 6:
            sender.setImage(#imageLiteral(resourceName: "up_full_selected.png"), for: .normal)
            instanEvents.swapEvents(swapEvent: 3, withEvent: 2)
        default:
            print("sender.tag=\(sender.tag) was unexpected")
        }
        
        displayEventSetWithoutYear()
        
        switch sender.tag {
        case 1:
            sender.setImage(#imageLiteral(resourceName: "down_full.png"), for: .normal)
        case 2,4:
            sender.setImage(#imageLiteral(resourceName: "up_half.png"), for: .normal)
        case 3,5:
            sender.setImage(#imageLiteral(resourceName: "down_half.png"), for: .normal)
        case 6:
            sender.setImage(#imageLiteral(resourceName: "up_full.png"), for: .normal)
        default:
            print("sender.tag=\(sender.tag) was unexpected")
        }    
    }

// move to TimerSupport class?
    func startStopTimer(command: String) {
        if command == "Start" {
            roundTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerDisplay), userInfo: nil, repeats: true)
        } else {
            roundTimer.invalidate()
            checkOrder()
        }
    }
    
    func updateTimerDisplay(timer: Timer) {
        if(count > 0) {
            count -= 1
            TimerDisplay.text = String(count)
        } else {
            startStopTimer(command: "Stop")
        }
    }
// to here
    
    func newGame() {
        setsShown = 1
        setsCorrect = 0
        rounds = 1
        count = 30
        instanEvents.refreshEventSet()
        self.loadViewIfNeeded()
        startStopTimer(command: "Start")
        displayEventSetWithoutYear()
    }

    func displayEventSetWithoutYear() {
        TimerDisplay.text = "30"
        Event1.text = instanEvents.eventSet[0].event
        Event2.text = instanEvents.eventSet[1].event
        Event3.text = instanEvents.eventSet[2].event
        Event4.text = instanEvents.eventSet[3].event
    }
    
    func displayEventSetWithYear() {
        var adjustedYears:[String] = ["0","1","2","3"]
        
        for i in 0...instanEvents.eventSet.count - 1 {
            if instanEvents.eventSet[i].year < 0 {
                adjustedYears[i] = "\(instanEvents.eventSet[i].year * -1)BC"
            } else {
                adjustedYears[i] = "\(instanEvents.eventSet[i].year)"
            }
        }
        
        Event1.text = "\(instanEvents.eventSet[0].event) - \(adjustedYears[0])\n\( instanEvents.eventSet[0].url)"
        Event2.text = "\(instanEvents.eventSet[1].event) - \(adjustedYears[1])\n\( instanEvents.eventSet[1].url)"
        Event3.text = "\(instanEvents.eventSet[2].event) - \(adjustedYears[2])\n\( instanEvents.eventSet[2].url)"
        Event4.text = "\(instanEvents.eventSet[3].event) - \(adjustedYears[3])\n\( instanEvents.eventSet[3].url)"
    }
    
    @IBAction func NextRound(_ sender: UIButton) {
        NextRoundButton.isHidden = true
        
        if rounds == roundsPerGame {
            // Display the results view controller  
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "ResultsView")
            self.present(controller, animated: true, completion: newGame)            
        } else {
            instanEvents.refreshEventSet()
            rounds += 1
            setsShown += 1
            count = 30
            startStopTimer(command: "Start")
            displayEventSetWithoutYear()
        }
    }
}

