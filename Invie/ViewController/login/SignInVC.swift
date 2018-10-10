//
//  SignInVC.swift
//  Invie
//
//  Created by Hitesh Thummar on 28/09/18.
//  Copyright © 2018 Hitesh Thummar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class SignInVC: UIViewController {

    
    
    @IBOutlet weak var lblBtnTitle: UILabel!
    @IBOutlet weak var txtNumber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        txtNumber.delegate = self
        
        
        lblBtnTitle.text = "Evenement aanmaken  "
        lblBtnTitle.addImage(imageName: "aerrow", afterLabel: true)
        
    }

    @IBAction func btnSignIn(_ sender: UIButton) {
        
//        self.view.endEditing(true)
//        AppDelegate.homeAsRoot()
//        IQKeyboardManager.shared.enable = true

        //return
        
        
        self.view.endEditing(true)
        
        
        
    
        
        if !txtNumber.text!.isContainText()
        {
            showToastMessage(msg: "Please enter phone number")
            return
        }
        
        if txtNumber.text!.count < 8
        {
            showToastMessage(msg: "Please enter valid phone number")
            return
        }
        
        
        let param = ["mo_no":txtNumber.text!.replacingOccurrences(of: "06-", with: "")]
        
        showLoader()
        APICall.call_API_ALL(url: API_LOGIN, param: param) { (dict) in
            
            if let success = dict.value(forKey: SUCCESS) as? Bool,success == true
            {
                if let d = dict.value(forKey: DATA_K) as? NSDictionary
                {
                    userDict = d;
                    saveUserData(dict: userDict)
                    AppDelegate.homeAsRoot()
                }
            }
                
            else
            {
                if let str = dict.value(forKey: "message") as? String
                {
                    showToastMessage(msg: str)
                }
            }
            
            hideLoader()
            IQKeyboardManager.shared.enable = true
        }        
    }
    
    @IBAction func btnSignUp(_ sender: UIButton) {
        
       self.dismiss(animated: true, completion: nil)
        
    }
    
}

extension SignInVC
{
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y = -keyboardSize.height + ((IphoneWithNotch || iPhone6_6s_7_8_Plus || iPhoneXS_MAX || iPhoneXR) ? 150 : iPhone6_6s_7_8 ? 50 : (iPhone5_SE || iPhone4) ? 70 : 0)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
           self.view.frame.origin.y = 0
        }
    }
}



extension SignInVC:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            
           /// if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
                //let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
                if textField.text == "06-"
                {
                    return false
                }
            //}
        }
        
        
        
       
        
        return true
    }
}
