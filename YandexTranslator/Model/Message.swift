//
//  Message.swift
//  YandexTranslator
//
//  Created by Egor Antipov on 12/28/18.
//  Copyright © 2018 Egor Antipov. All rights reserved.
//

import Foundation

class Message {
    
    private var _originalText : String!
    private var _translationText : String!
    
    var originalText : String {
        return _originalText
    }
    
    var translationText : String {
        return _translationText
    }
    
    init(originalText: String, translationText: String) {
        _originalText = originalText
        _translationText = translationText
    }
}
