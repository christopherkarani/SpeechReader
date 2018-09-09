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
    

    
    let synthesizer = AVSpeechSynthesizer()
    
    
    let inputTextField: SpringTextField = {
        let tf = SpringTextField()
        tf.placeholder = "Enter Some Text"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        return tf
    }()
    
    
    let readButton : SpringButton = {
        let button = SpringButton(type: .system)
        button.setTitle("Read Text", for: .normal)
        button.backgroundColor = UIColor.flatGreen
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(speakAction), for: .touchUpInside)
        button.shadow(with: .flatGray, opacity: 0.7, offset: CGSize(width: 0.5, height: 5), radius: 2)
        return  button
    }()
    
    let repeatButton: SpringButton = {
        let button = SpringButton(type: .system)
        button.setTitle("Repeat", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(repeatSpeechAction), for: .touchUpInside)
        button.shadow(with: .flatGray, opacity: 0.7, offset: CGSize(width: 0.5, height: 5), radius: 2)
        return  button
    }()
    
    let commonWordsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        return view
    }()
    

    
    var repeatText: String?
    
    
    // handle repeat action
    @objc func repeatSpeechAction() {
        guard let text = repeatText else { return }
        animate(button: .repeat)
        let utterance = AVSpeechUtterance(string: text)
        let voices : Voices = .english
        utterance.voice = AVSpeechSynthesisVoice(language: voices.language)
        if !synthesizer.isSpeaking {
            synthesizer.speak(utterance)
        }
    }
    
    fileprivate func handleTextFieldErrorAnimation() {
        inputTextField.animation = "shake"
        inputTextField.curve = "spring"
        inputTextField.duration = 0.5
        inputTextField.animate()
    }
    
    /*
     a helper enum for button selection
 */
    
    enum ButtonType {
        case read, `repeat`
    }
    
    fileprivate func animate(button type: ButtonType) {
        switch type {
        case .read:
            readButton.scaleX = 0.90
            readButton.scaleY = 0.90
            readButton.duration = 1
            readButton.animate()
        case .repeat:
            repeatButton.scaleX = 0.90
            repeatButton.scaleY = 0.90
            repeatButton.duration = 1
            repeatButton.animate()
        }
    }
    
    
    // handle speaking
    @objc func speakAction() {
        guard let text = inputTextField.text, !text.isEmpty else {
            handleTextFieldErrorAnimation()
            return
        }
        
        animate(button: .read)
        
        
        let utterance = AVSpeechUtterance(string: text)
        let voices : Voices = .english
        utterance.voice = AVSpeechSynthesisVoice(language: voices.language)
        synthesizer.speak(utterance)
        repeatText = text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.repeatButton.backgroundColor = UIColor.flatRed
            self.repeatButton.setTitleColor(.white, for: .normal)
        }
        
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
        view.addSubview(repeatButton)
        view.addSubview(commonWordsContainerView)
        
        
        
        // input textFIeld contrainsts
        inputTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            $0.width.equalToSuperview().inset(14)
            $0.height.equalTo(50)
        }
        
        // read button constraints
        readButton.snp.makeConstraints {
            $0.top.equalTo(inputTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(inputTextField.snp.width).multipliedBy(1.5/3)
            $0.height.equalTo(40)
        }
        
        // repeat button constraints
        repeatButton.snp.makeConstraints {
            $0.top.equalTo(readButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(inputTextField.snp.width).multipliedBy(1.5/3)
            $0.height.equalTo(40)
        }
        
        // common words container view constraints
        commonWordsContainerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(repeatButton.snp.bottom).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.width.equalToSuperview().inset(14)
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

