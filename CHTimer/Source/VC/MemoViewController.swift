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
    var numberOfCharacters: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "메모 추가하기"
        
        memoTextVIew.delegate = self
        
        memoTextVIew.layer.cornerRadius = 10
        memoTextVIew.textColor = UIColor.systemGray
        memoTextVIew.layer.borderColor = UIColor.black.cgColor
        
        let rightBarButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem(title: "취소", style: .done, target: self, action: #selector(cancelButton))
        self.navigationItem.leftBarButtonItem = leftBarButton
    
        if let addMemo = addMemo {
            lapLabel.text = addMemo.lap
            percentLabel.text = "( \(addMemo.percent)% 경과 )"
        }
        
    }
    
    @objc func saveButton() {
        if numberOfCharacters > 50 {
            UIAlertController.showAlert(message: "50자 이내로 작성해주세요.", vc: self)
        } else {
            
        }
    }
    
    @objc func cancelButton() {
        self.dismiss(animated: true)
    }

}

extension MemoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메모를 작성하세요."
            textView.textColor = .systemGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        textLimitLabel.text = "(\(changedText.count)/50)"
        if changedText.count > 50 {
            textView.textColor = .systemRed
            textLimitLabel.textColor = .systemRed
        } else {
            textView.textColor = .black
            textLimitLabel.textColor = .black
        }
        numberOfCharacters = changedText.count
        return changedText.count <= 100000
    }
}
