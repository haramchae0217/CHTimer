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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "메모 추가하기"
        
        let rightBarButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
    
        
        
    }
    
    @objc func saveButton() {
        
    }
    
    @objc func cancelButton() {
        
    }

}
