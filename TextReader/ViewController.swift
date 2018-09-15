//
//  ViewController.swift
//  TextReader
//
//  Created by Chris Karani on 08/09/2018.
//  Copyright © 2018 Chris Karani. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import ChameleonFramework
import Spring





class ViewController: UIViewController {
    
    var textReaderInputView: TextReaderInputView = {
        let view = TextReaderInputView(with: AVSpeechSynthesizer())
        return view
    }()
    
    let commonWordsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISetup()
        setupGestures()
        setupUIElements()
        setupKeyboardNotifications()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeKeyboardNotifications()
    }
    
    
    fileprivate func initialUISetup() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Speech Reader"
    }
    
    fileprivate func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction))
        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboardAction() {
        view.endEditing(true)
    }
    
    private func setupUIElements() {
        view.addSubview(textReaderInputView)

//        view.addSubview(commonWordsContainerView)
        
        
        
        // input view contrainsts
        textReaderInputView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            $0.width.equalToSuperview().inset(14)
            $0.height.equalTo(50)
        }
        
        
        
        
//
//        // common words container view constraints
//        commonWordsContainerView.snp.makeConstraints {
//            $0.centerX.equalToSuperview()
//            $0.top.equalTo(repeatButton.snp.bottom).offset(16)
//            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            $0.width.equalToSuperview().inset(14)
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
// handling Keyboard appearance, observers
extension ViewController {
    // convinience variable to help clean up
    var notification : NotificationCenter {
        return NotificationCenter.default
    }
    
    func setupKeyboardNotifications() {
        notification.addObserver(self, selector: #selector(handleShowKeyboard(notification:)), name: .UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(handleHideKeyboard(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotifications() {
        notification.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleShowKeyboard(notification: Notification) {
        guard let dict = notification.userInfo else { return }
        guard view.frame.origin.y == 0.0 else { return }
        let frame = dict["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        let height = frame.height / 4
        print(height)
        view.frame.origin.y -= height
        
    }
    
    @objc func handleHideKeyboard(notification: Notification) {
        guard let dict = notification.userInfo else { return }
        let frame = dict["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        let height = frame.height / 4
        view.frame.origin.y += height
    }
}

