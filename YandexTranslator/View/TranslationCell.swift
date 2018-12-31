//
//  TranslationCell.swift
//  YandexTranslator
//
//  Created by Egor Antipov on 12/29/18.
//  Copyright © 2018 Egor Antipov. All rights reserved.
//

import Foundation
import UIKit

class TranslationCell: UITableViewCell {
    
    var firstLabelOne: String?
    var secondLabelTwo: String?
    
    var firstLabelView : UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Baskerville", size: 22)
        return textView
    }()
    
    var secondLabelView : UITextView = {
        var textViewTwo = UITextView()
        textViewTwo.translatesAutoresizingMaskIntoConstraints = false
        textViewTwo.isScrollEnabled = false
        textViewTwo.font = UIFont(name: "Verdana", size: 30)
        return textViewTwo
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(firstLabelView)
        self.addSubview(secondLabelView)
        
        // Set Anchors
        firstLabelView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        firstLabelView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        firstLabelView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        firstLabelView.bottomAnchor.constraint(equalTo: secondLabelView.topAnchor).isActive = true
        
        secondLabelView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        secondLabelView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        secondLabelView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let firstLabelOne = firstLabelOne {
            firstLabelView.text = firstLabelOne
        }
        
        if let secondLabelTwo = secondLabelTwo {
            secondLabelView.text = secondLabelTwo
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    var translation: Translation!
    
    func configureCell(translation: Translation) {
        self.translation = translation
        
        /*
        if selectedLanguage == "Rus" {
            
            sentMessageLabel.text = message.originalText
            sendMessageView.isHidden = false
            receivedMessageLabel.text = ""
            receivedMessageView.isHidden = true
            
            
        } else {
            
            sentMessageLabel.text = ""
            sendMessageView.isHidden = true
            receivedMessageLabel.text = message.originalText
            receivedMessageView.isHidden = false
        */
 
            
        }
        
        
        
        
        
    }
