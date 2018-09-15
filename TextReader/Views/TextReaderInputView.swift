
//
//  File.swift
//  TextReader
//
//  Created by Chris Karani on 15/09/2018.
//  Copyright © 2018 Chris Karani. All rights reserved.
//

import UIKit
import Spring
import AVFoundation
import SnapKit

final class TextReaderInputView: UIView {
    
    var synthesizer: AVSpeechSynthesizer
    var repeatText: String?
    
    
    let inputTextField: SpringTextField = {
        let tf = SpringTextField()
        tf.placeholder = "Enter Some Text"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        return tf
    }()
    
    
    public lazy var readButton : SpringButton = {
        let button = SpringButton(type: .system)
        button.setTitle("Read Text", for: .normal)
        button.backgroundColor = UIColor.flatGreen
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        //button.addTarget(self, action: #selector(actions.read), for: .touchUpInside)
        button.shadow(with: .flatGray, opacity: 0.7, offset: CGSize(width: 0.5, height: 5), radius: 2)
        return  button
    }()
    
    public lazy var repeatButton: SpringButton = {
        let button = SpringButton(type: .system)
        button.setTitle("Repeat", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        //button.addTarget(self, action: #selector(actions.repeat), for: .touchUpInside)
        button.shadow(with: .flatGray, opacity: 0.7, offset: CGSize(width: 0.5, height: 5), radius: 2)
        return  button
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [readButton, repeatButton])
        stackView.backgroundColor = .yellow
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    
    
    
    init(with synthesizer: AVSpeechSynthesizer) {
        self.synthesizer = synthesizer
        
        super.init(frame: .zero)
        
        setupUI()
    }
    
    fileprivate func setupUI() {
        addSubview(inputTextField)
        addSubview(buttonsStackView)
        
        inputTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(inputTextField.snp.bottom).offset(20)
            $0.width.equalTo(inputTextField.snp.width)
            $0.height.equalTo(30)
        }
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
    
    
    // error animation
    fileprivate func handleTextFieldErrorAnimation() {
        inputTextField.animation = "shake"
        inputTextField.curve = "spring"
        inputTextField.duration = 0.5
        inputTextField.animate()
    }
    
    // handle repeat action
    @objc func repeatSpeechAction() {
        guard let text = repeatText else { return }
        // press down animation
        animate(button: .repeat)
        let utterance = AVSpeechUtterance(string: text)
        let voices : Voices = .english
        utterance.voice = AVSpeechSynthesisVoice(language: voices.language)
        if !synthesizer.isSpeaking {
            synthesizer.speak(utterance)
        }
    }
    
    // handle speaking
    @objc func speakAction() {
        guard let text = inputTextField.text, !text.isEmpty else {
            handleTextFieldErrorAnimation()
            return
        }
        
        
        // press down animation
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
