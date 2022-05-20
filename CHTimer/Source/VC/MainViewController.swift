//
//  ViewController.swift
//  CHTimer
//
//  Created by Chae_Haram on 2022/05/09.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonSet()
        limitTimeSet()
    }
    
    func buttonSet() {
        startButton.layer.cornerRadius = 10
    }
    
    func limitTimeSet() {
        timePicker.addTarget(self, action: #selector(respond(picker:)), for: .valueChanged)
        var components = DateComponents()
        components.minute = 1
        let date = Calendar.current.date(from: components)!
        timePicker.setDate(date, animated: true)
    }
    
    @objc func respond(picker: UIDatePicker) {
        if picker.countDownDuration > 36000 {
            UIAlertController.showAlert(message: "최대 설정시간은 10시간입니다.", viewController: self)
            var components = DateComponents()
            components.hour = 10
            let date = Calendar.current.date(from: components)!
            picker.setDate(date, animated: true)
        }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        guard let timeVC = self.storyboard?.instantiateViewController(withIdentifier: TimerViewController.identifier) as? TimerViewController else { return }
        timeVC.setTime = Float(timePicker.countDownDuration)
        timeVC.modalPresentationStyle = .fullScreen
        self.present(timeVC, animated: true)
        
    }
    
}

