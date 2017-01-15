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

        // cannot access counters in GameViewController..?
        GameScore.text = "\(setsCorrect) out of \(setsShown) correctly ordered sets"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ReturnToGame(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
