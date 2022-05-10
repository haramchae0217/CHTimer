//
//  MemoViewController.swift
//  CHTimer
//
//  Created by Chae_Haram on 2022/05/09.
//

import UIKit

class MemoViewController: UIViewController {

    static var identifier = "MemoVC"
    
    @IBOutlet weak var lapLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var memoTextVIew: UITextView!
    @IBOutlet weak var textLimitLabel: UILabel!
    
    var addMemo: Laps?
    var row: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "메모 추가하기"
        print(addMemo)
        let rightBarButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
    
        if let addMemo = addMemo {
            lapLabel.text = addMemo.lap
            percentLabel.text = "( \(addMemo.percent)% 경과 )"
            memoTextVIew.text = addMemo.memo
        }
        
    }
    
    @objc func saveButton() {
        
    }
    
    @objc func cancelButton() {
        
    }

}
