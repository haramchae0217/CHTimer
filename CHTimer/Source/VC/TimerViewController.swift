//
//  TimerViewController.swift
//  CHTimer
//
//  Created by Chae_Haram on 2022/05/09.
//

import UIKit

class TimerViewController: UIViewController {

    static var identifier = "TimerVC"
    
    var timer = Timer()
    var timeInt: Int = Int()
    var hours: Int = Int()
    var minutes: Int = Int()
    var seconds: Int = Int()
    var elapsedTimeSeconds: Int = Int()
    var remainSeconds: Int = Int()
    var type: currentType = .start
    
    enum currentType {
        case start
        case pause
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timeProgressBar: UIProgressView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var replayButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
        
        alertLabel.isHidden = true
        startTimer(with: timeInt)
        
    }
    
    func startTimer(with countDownSeconds: Int) {
        let startTime = Date()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] timer in
            elapsedTimeSeconds = Int(Date().timeIntervalSince(startTime))
            remainSeconds = countDownSeconds - elapsedTimeSeconds
            guard remainSeconds >= 0 else {
                timer.invalidate()
                return
            }
            hours = remainSeconds / 3600
            minutes = (remainSeconds % 3600) / 60
            seconds = remainSeconds % 60
        
            if hours == 0 && minutes == 0 && seconds <= 10 {
                alertLabel.isHidden = false
                timerLabel.textColor = .red
            }
            if hours == 0 && minutes == 0 && seconds == 0 {
                UIAlertController.timeEndAlert(message: "타이머가 종료되었습니다.", vc: self)
            }
            self.timerLabel.text = String(format: "%02d : %02d : %02d", hours, minutes, seconds)
        })
    }
    
    @IBAction func replayButton(_ sender: UIButton) {
        if type == .start {
            replayButton.setTitle("다시시작", for: .normal)
            replayButton.backgroundColor = .systemGreen
            timer.invalidate()
            type = .pause
        } else {
            replayButton.setTitle("일시정지", for: .normal)
            replayButton.backgroundColor = .systemGray2
            startTimer(with: remainSeconds)
            type = .start
        }
    }
    
    @IBAction func lapButton(_ sender: UIButton) {
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        
    }
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = 
        
        return cell
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
