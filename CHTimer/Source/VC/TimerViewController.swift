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
    var setTime: Float = 0
    var fixedTime: Float = 0
    var progress: Float = 1
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var milliseconds: Int = 0
    var timeInterver: Float = 0
    var currentType: CurrentType = .play
    var timerType: TimerType = .hour
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
        
        fixedTime = setTime
        
        if setTime >= 3600 {
            timerType = .hour
        } else {
            timerType = .minute
        }

        startTimer()
        buttonSet()
        progressBarSet()
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
    
    func reduceProgess(type: TimerType) {
        let interval: Float = type == .hour ? 1.0 : 0.001
        let reduceTime = interval / Float(fixedTime)
        progress -= reduceTime
        timeProgressBar.setProgress(progress, animated: true)
        
        hours = Int(setTime / 3600)
        minutes = (Int(setTime) % 3600) / 60
        seconds = Int(setTime) % 60
        milliseconds = Int((setTime - floor(setTime)) * 100)
        
        setTime -= interval
        
        if type == .hour {
            if hours == 0 && minutes == 0 {
                if seconds == 0 {
                    timer.invalidate()
                    UIAlertController.timeEndAlert(message: "타이머가 종료되었습니다.", viewController: self)
                } else if seconds <= 10 {
                    alertLabel.isHidden = false
                    timerLabel.textColor = .red
                    timeProgressBar.progressTintColor = .red
                }
            }
            self.timerLabel.text = String(format: "%02d : %02d : %02d", hours, minutes, seconds)
        } else {
            if minutes == 0 && milliseconds == 0 {
                if seconds == 0 {
                    timer.invalidate()
                    UIAlertController.timeEndAlert(message: "타이머가 종료되었습니다.", viewController: self)
                } else if seconds <= 10 {
                    alertLabel.isHidden = false
                    timerLabel.textColor = .red
                    timeProgressBar.progressTintColor = .red
                }
            }
            self.timerLabel.text = String(format: "%02d : %02d : %02d", minutes, seconds, milliseconds)
        }
    }
    
    @objc func setTimer() {
        reduceProgess(type: timerType)
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
            recentTime = round(Double(setTime))
        } else {
            recentTime = Double(setTime)
        }
        
        var percent = 100 - ((Double(recentTime) / Double(fixedTime)) * 100)
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
            UIAlertController.showAlert(message: "타이머를 멈추고 다시 시도해주세요.", viewController: self)
        } else {
            guard let memoNC = self.storyboard?.instantiateViewController(withIdentifier: "MemoNC") as? UINavigationController else { return }
            guard let memoVC = memoNC.children.first as? MemoViewController else { return }
            
            let item = Laps.laps[indexPath.row]
            memoVC.type = item.memo == "추가 메모 없음" ? .add : .edit
            memoVC.addMemo = item
            memoVC.row = indexPath.row
            
            memoNC.modalPresentationStyle = .fullScreen
            self.present(memoNC, animated: true)
        }
    }
}
