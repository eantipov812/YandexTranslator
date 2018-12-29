//
//  MessagesCell.swift
//  YandexTranslator
//
//  Created by Egor Antipov on 12/28/18.
//  Copyright © 2018 Egor Antipov. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var receivedMessageLabel: UILabel!
    @IBOutlet weak var receivedMessageView: UIView!
    @IBOutlet weak var sentMessageLabel: UILabel!
    @IBOutlet weak var sendMessageView: UIView!
    
    
    var message: Message!
    var selectedLanguage = "Rus"
    
    func configureCell(message: Message) {
        self.message = message
        
        
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
            
            
            
        }
        
    }
    
}
