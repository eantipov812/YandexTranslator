//
//  MainTranslationVC.swift
//  YandexTranslator
//
//  Created by Egor Antipov on 12/29/18.
//  Copyright © 2018 Egor Antipov. All rights reserved.
//

import UIKit

struct CellData {
    var firstMessage: String?
    var secondMessage: String?
}

class MainTranslationVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var languagePickerView: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // Set Languages
    let languages = ["en", "ru"]
    
    var translations = [Translation]()
    var translation: Translation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize Delegates and Data Sources
        tableView.dataSource = self
        tableView.delegate = self
        languagePickerView.dataSource = self
        languagePickerView.delegate = self
        
        // Add Keyboard Handling
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        tableView.register(TranslationCell.self, forCellReuseIdentifier: "translationCellID")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
    }
    
    // MARK: Keyboard Handling
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: TABLE VIEW
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "translationCellID") as! TranslationCell
        cell.firstLabelOne = translations[indexPath.row].originalText
        cell.secondLabelTwo = translations[indexPath.row].translationText
        cell.layoutSubviews()
        return cell
    }
    
    
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        let newItem = Translation()
        newItem.originalText = textField.text!
        newItem.translationText = textField.text! + "%"
        self.translations.append(newItem)
        // Dismiss Keyboard Once Translation is Sent
        view.endEditing(true)
        textField.text = ""
        self.tableView.reloadData()
        
        
        
    }
    
    
}

extension MainTranslationVC : UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Function Number of Components Within 1 Row
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Function Number of Rows in the Picker View
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowLabel : String?
        switch row {
        case 0:
            rowLabel = "🇺🇸"
        case 1:
            rowLabel = "🇷🇺"
        default:
            rowLabel = nil
        }
        return rowLabel
    }
    
}
