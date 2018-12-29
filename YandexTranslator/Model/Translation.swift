//
//  Translation.swift
//  YandexTranslator
//
//  Created by Egor Antipov on 12/29/18.
//  Copyright © 2018 Egor Antipov. All rights reserved.
//

import Foundation
import UIKit

class Translation {
    
    // Initialize Variables
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
