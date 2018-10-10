//
//  ViewController.swift
//  Invie
//
//  Created by Hitesh Thummar on 28/09/18.
//  Copyright © 2018 Hitesh Thummar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if (USERDEFAULTS.value(forKey: ISLOGIN_K) != nil)
        {
            if let mobile = USERDEFAULTS.value(forKey: MOBILE_K)
            {
                let param = ["mo_no":"\(mobile)"]
                APICall.call_API_ALL(url: API_LOGIN, param: param) { (dict) in
                    
                    if let success = dict.value(forKey: SUCCESS) as? Bool,success == true
                    {
                        if let d = dict.value(forKey: DATA_K) as? NSDictionary
                        {
                            userDict = d;
                            //saveUserData(dict: userDict)
                            AppDelegate.homeAsRoot()
                            IQKeyboardManager.shared.enable = true
                        }
                    }
                        
                    else
                    {
                       AppDelegate.loginAsRoot()
                    }
                }
            }
        }
        else
        {
            AppDelegate.loginAsRoot()
        }        
    }

}

