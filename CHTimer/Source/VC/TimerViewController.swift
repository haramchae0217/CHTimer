//
//  TimerViewController.swift
//  CHTimer
//
//  Created by Chae_Haram on 2022/05/09.
//

import UIKit

class TimerViewController: UIViewController {

    static var identifier = "TimerVC"
    
    var timeInt: Int = Int()
    var hours: Int = Int()
    var minutes: Int = Int()
    var seconds: Int = Int()
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timeProgressBar: UIProgressView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hours = timeInt / 3600
        minutes = (timeInt % 3600) / 60
        seconds = timeInt % 60
        
        timerLabel.text = "\(hours) : \(minutes) : \(seconds)"
        print(timeInt)
        print(hours)
        print(minutes)
        print(seconds)

    }
    
    @IBAction func replayButton(_ sender: UIButton) {
        
    }
    
    @IBAction func lapButton(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        
    }
    
    
    
    
    
}
