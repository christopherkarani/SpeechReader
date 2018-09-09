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

class ViewController: UIViewController {
    

    
    let synthesizer = AVSpeechSynthesizer()
    
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Some Text"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        return tf
    }()
    
    
    let readButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read Text", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(speakAction), for: .touchUpInside)
        return  button
    }()
    
    
    @objc func speakAction() {
        guard let text = inputTextField.text else { return }
        
        let utterance = AVSpeechUtterance(string: text)
        synthesizer.speak(utterance)
        
        inputTextField.text = nil
    }

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
        view.addSubview(inputTextField)
        view.addSubview(readButton)
        
        inputTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().inset(14)
            $0.height.equalTo(50)
        }
        
        readButton.snp.makeConstraints {
            $0.top.equalTo(inputTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(inputTextField.snp.width).multipliedBy(1.5/3)
            $0.height.equalTo(40)
        }
        
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
        let frame = dict["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        let height = frame.height / 4
        view.frame.origin.y -= height
        
    }
    
    @objc func handleHideKeyboard(notification: Notification) {
        guard let dict = notification.userInfo else { return }
        let frame = dict["UIKeyboardFrameEndUserInfoKey"] as! CGRect
        let height = frame.height / 4
        view.frame.origin.y += height
    }
}

