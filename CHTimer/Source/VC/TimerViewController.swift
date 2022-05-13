//
//  TimerViewController.swift
//  CHTimer
//
//  Created by Chae_Haram on 2022/05/09.
//

import UIKit

class TimerViewController: UIViewController {

    static var identifier = "TimerVC"
    
    enum CurrentType {
        case play
        case pause
    }
    
    enum TimerType {
        case hour
        case minute
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timeProgressBar: UIProgressView!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var lapButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var timer = Timer()
    var setTime: Int = 0
    var hourTime: Int = 0
    var milliTime: Double = 0
    var progress: Float = 1
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var milliseconds: Int = 0
    var currentType: CurrentType = .play
    var timerType: TimerType = .hour
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
        
        if setTime >= 3600 {
            timerType = .hour
            hourTime = setTime
        } else {
            timerType = .minute
            milliTime = Double(setTime)
        }

        buttonSet()
        progressBarSet()
        startTimer()
        alertLabel.isHidden = true
        
        lapsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        lapsTableView.reloadData()
    }
    
    func progressBarSet() {
        timeProgressBar.progressViewStyle = .default
        timeProgressBar.progressTintColor = .systemBlue
        timeProgressBar.trackTintColor = .lightGray
        timeProgressBar.transform = timeProgressBar.transform.scaledBy(x: 1, y: 3)
        timeProgressBar.layer.cornerRadius = 8
        timeProgressBar.setProgress(progress, animated: true)
    }
    
    func buttonSet() {
        replayButton.layer.cornerRadius = 10
        lapButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
    }
    
    func startTimer() {
        if timerType == .hour {
            goTimer(interval: 1)
        } else {
            goTimer(interval: 0.001)
        }
    }
    
    func goTimer(interval: TimeInterval){
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(setTimer), userInfo: nil, repeats: true)
    }
    
    @objc func setTimer() {
        if timerType == .hour {
            let reduceTime = 1.0/Float(setTime)
            progress -= reduceTime
            timeProgressBar.setProgress(progress, animated: true)
            
            hourTime -= 1
            hours = hourTime / 3600
            minutes = (hourTime % 3600) / 60
            seconds = hourTime % 60
            
            if hours == 0 && minutes == 0 && seconds <= 10 {
                alertLabel.isHidden = false
                timerLabel.textColor = .red
                timeProgressBar.progressTintColor = .red
            }
            
            if hours == 0 && minutes == 0 && seconds == 0 {
                timer.invalidate()
                UIAlertController.timeEndAlert(message: "타이머가 종료되었습니다.", viewcontroller: self)
            }
            
            self.timerLabel.text = String(format: "%02d : %02d : %02d", hours, minutes, seconds)
        } else {
            let reduceTime = 1.0/Float(setTime*900)
            print(reduceTime)
            progress -= reduceTime
            timeProgressBar.setProgress(progress, animated: true)
            
            milliTime -= 0.001
            minutes = (Int(milliTime) % 3600) / 60
            seconds = Int(milliTime) % 60
            milliseconds = Int((milliTime - floor(milliTime)) * 100)
        
            if minutes == 0 && seconds <= 10 {
                alertLabel.isHidden = false
                timerLabel.textColor = .red
                timeProgressBar.progressTintColor = .red
            }
            
            if minutes == 0 && seconds == 0 && milliseconds == 0 {
                timer.invalidate()
                UIAlertController.timeEndAlert(message: "타이머가 종료되었습니다.", viewcontroller: self)
            }
            
            self.timerLabel.text = String(format: "%02d : %02d : %02d", minutes, seconds, milliseconds)
        }
    }
    
    @IBAction func replayButton(_ sender: UIButton) {
        if currentType == .play {
            timer.invalidate()
            replayButton.setTitle("다시시작", for: .normal)
            replayButton.backgroundColor = .systemGreen
            currentType = .pause
        } else {
            startTimer()
            replayButton.setTitle("일시정지", for: .normal)
            replayButton.backgroundColor = .systemGray2
            currentType = .play
        }
    }
    
    @IBAction func lapButton(_ sender: UIButton) {
        let lap = timerLabel.text!
        var recentTime: Double = 0
        
        if timerType == .hour {
            recentTime = round(Double(hourTime))
        } else {
            recentTime = milliTime
        }
        
        var percent = 100 - ((Double(recentTime) / Double(setTime)) * 100)
        percent = round(percent * 10) / 10
        
        if percent > 100 {
            percent = 100
        }
        
        let addLap = Laps(lap: lap, percent: percent)
        Laps.laps.append(addLap)
        let sortData = Laps.laps.sorted(by: { $0.percent > $1.percent })
        Laps.laps = sortData
        
        lapsTableView.reloadData()
        
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        timer.invalidate()
        Laps.laps = []
        self.dismiss(animated: true)
    }
}

extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LapsTableViewCell.identifier, for: indexPath) as? LapsTableViewCell else { return UITableViewCell() }
        let lapCell = Laps.laps[indexPath.row]
        
        cell.lapLabel.text = lapCell.lap
        cell.percentLabel.text = "( \(lapCell.percent)% 경과 )"
        cell.memoLabel.text = lapCell.memo
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Laps.laps.count
    }
}

extension TimerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentType == .play {
            UIAlertController.showAlert(message: "타이머를 멈추고 다시 시도해주세요.", viewcontroller: self)
        } else {
            guard let memoNC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemoNC") as? UINavigationController else { return }
            guard let memoVC = memoNC.children.first as? MemoViewController else { return }
        
            memoVC.addMemo = Laps.laps[indexPath.row]
            memoVC.row = indexPath.row
            
            memoNC.modalPresentationStyle = .fullScreen
            self.present(memoNC, animated: true)
        }
    }
}
