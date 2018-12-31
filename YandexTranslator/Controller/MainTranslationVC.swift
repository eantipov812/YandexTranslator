//
//  MainTranslationVC.swift
//  YandexTranslator
//
//  Created by Egor Antipov on 12/29/18.
//  Copyright © 2018 Egor Antipov. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

// struct CellData {
//    var firstMessage: String?
//    var secondMessage: String?
// }

class MainTranslationVC: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var languagePickerView: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    
    // Initialize Context to Manage Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Set Languages
    let languages = ["en", "ru"]
    var originalLang : String = "en"
    
    var translations = [TranslationEntity]()
    var translation: Translation!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation Controller Item Name
        navigationItem.title = "Яндекс Переводчик"
        
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
        tableView.separatorColor = UIColor.clear
        
        // Load all of the Translations
        loadItems()
        
        // Textfield Placeholder
        bottomView.backgroundColor = UIColor(red:0.07, green:0.39, blue:0.89, alpha:1.0)
        bottomView.layer.cornerRadius = 28
        textField.backgroundColor = UIColor.clear
        textField.font = UIFont(name: "Verdana", size: 16)
        textField.textColor = UIColor.white
        textField.borderStyle = .none
        textField.attributedPlaceholder = NSAttributedString(string: "Английский", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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
    
    // TABLE VIEW - METHOD TO RETURN NUMBER OF ROWS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations.count
    }
    
    // TABLE VIEW - METHOD TO UPDATE TABLE VIEW CELLS
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "translationCellID") as! TranslationCell
        cell.firstLabelOne = translations[indexPath.row].originalText
        cell.secondLabelTwo = translations[indexPath.row].translatedText
        cell.layoutSubviews()
        // No Separator Within Table View
        tableView.separatorColor = UIColor.clear
        return cell
    }
    
    // TABLE VIEW - METHOD TO DELETE ROWS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            context.delete(translations[indexPath.row])
            translations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveItems()
        }
        
        
    }
    
    
    // MARK: SEND BUTTON
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        let newItem = TranslationEntity(context: context)
        newItem.originalText = textField.text!
        var langTemp = ""
        
        // Determine Direction of the translation
        if originalLang == "ru" {
            langTemp = "ru-en"
        } else {
            langTemp = "en-ru"
        }
        
        // Set Parameters
        let params : [String:String] = ["key": Constants.apiKey, "text": textField.text!, "lang" : langTemp]
        
        // Initialize Alamofire Request (REMEMBER! ASYNC REQUEST)
        Alamofire.request(Constants.translateURL, method: .get, parameters: params).responseJSON { (response) in
            
            if response.result.isSuccess {
                let responseReturnTemp : JSON =  JSON(response.result.value!)
                newItem.translatedText = (responseReturnTemp["text"].arrayValue.first?.string!)!
                self.translations.append(newItem)
                // Dismiss Keyboard Once Translation is Sent
                self.view.endEditing(true)
                self.textField.text = ""
                self.tableView.reloadData()
            } else {
                print("Error With Translation!")
            }
        }
    }
    
    // MARK: HELPER FUNCTIONS
    func saveItems(){
        
        do {
           try context.save()
        } catch {
            print("Error Saving Context")
        }
        tableView.reloadData()
        
    }
    
    func loadItems(){
        let request : NSFetchRequest<TranslationEntity> = TranslationEntity.fetchRequest()
        do {
         translations = try context.fetch(request)
        } catch {
            print("Error Fetching Data from Context: \(error)")
        }
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
    
    // Select Row of Picker View
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch row {
        case 0:
            originalLang = "en"
            bottomView.backgroundColor = UIColor(red:0.07, green:0.39, blue:0.89, alpha:1.0)
            bottomView.layer.cornerRadius = 28
            textField.backgroundColor = UIColor.clear
            textField.font = UIFont(name: "Verdana", size: 16)
            textField.attributedPlaceholder = NSAttributedString(string: "Английский", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        case 1:
            originalLang = "ru"
            bottomView.backgroundColor = UIColor(red:0.90, green:0.20, blue:0.29, alpha:1.0)
            bottomView.layer.cornerRadius = 28
            textField.backgroundColor = UIColor.clear
            textField.font = UIFont(name: "Verdana", size: 16)
            textField.attributedPlaceholder = NSAttributedString(string: "Русский", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        default:
            textField.placeholder = ""
        }
        
     

        
        
        
        
    }
    
    
}
