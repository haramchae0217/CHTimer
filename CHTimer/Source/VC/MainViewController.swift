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
    }
    
    func buttonSet() {
        startButton.layer.cornerRadius = 10
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        guard let moveTimeVC = self.storyboard?.instantiateViewController(withIdentifier: TimerViewController.identifier) as? TimerViewController else { return }
        moveTimeVC.setTime = Int(timePicker.countDownDuration)
        moveTimeVC.modalPresentationStyle = .fullScreen
        self.present(moveTimeVC, animated: true)
        
    }
    
}

