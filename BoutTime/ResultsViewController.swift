//
//  ResultsViewController.swift
//  BoutTime
//
//  Created by Roger Rohweder on 1/11/17.
//  Copyright © 2017 Roger Rohweder. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var GameScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GameScore.text = "\(setsCorrect) out of \(setsShown) correctly ordered sets"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ReturnToGame(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
