//
//  ViewController.swift
//  CHTimer
//
//  Created by Chae_Haram on 2022/05/09.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        guard let moveTimeVC = self.storyboard?.instantiateViewController(withIdentifier: TimerViewController.identifier) as? TimerViewController else { return }
        moveTimeVC.setTime = Int(timePicker.countDownDuration)
        moveTimeVC.modalPresentationStyle = .fullScreen
        self.present(moveTimeVC, animated: true)
        
    }
    
}

