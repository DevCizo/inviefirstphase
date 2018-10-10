//
//  API.swift
//  Men Of Joy
//
//  Created by Hitesh Thummar on 17/08/18.
//  Copyright © 2018 Hitesh Thummar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/*
1: Birthday
2: Drinks & Diner
3: Theme event:
4: Appointment
5: Custom event

*/

struct AppUrl
{
    static let base_url = "http://18.224.16.91/api/v1/"
}

let SUCCESS = "success"

// url
let API_REGISTER = AppUrl.base_url + "register"
let API_LOGIN = AppUrl.base_url + "login"
let API_EVENTLIST = AppUrl.base_url + "elist"
let API_ADDEVENT = AppUrl.base_url + "addevent"
let API_EVENTDETAIL = AppUrl.base_url + "edetail"


// key

let DATA_K = "data"
let NAME_K = "name"
let MOBILE_K = "mo_no"
let ID_K = "id"
let ISLOGIN_K = "isLogin"
let USERID_K = "user_id"
let PAGE_K = "page"
let DATETIME_K = "date_time"
let GOING_K = "going"
let NOTGOING_K = "not_going"
let EVENTTYPE_K = "event_type"
let MESSAGE_K = "message"
let STARTTIME_K = "start_time"
let ENDTIME_K = "end_time"

class APICall: NSObject
{
    
    class func call_API_ALL(url:String,param:[String:Any],handlerCompletion:@escaping (_ resDict:NSDictionary) -> Void) {
        
        print("Send URL:---->\(url)");
        
        print("Send Dict:---->\(param)");
        
        
        
        if isConnectedToNetwork() == false
        {
            let dict = ["success":false,"message":"No internet available."] as [String : Any]
            handlerCompletion(dict as NSDictionary)
            
        }
        
        
        
        Alamofire.request(url, method: .post, parameters: param).responseJSON { response in
            
            
            //            guard (response.result.value as? JSON) != nil else {
            //
            //                print("parsing fail")
            //                return
            //
            //            }
            
            // print(response.error)
            let finalJSON = try? JSON(data: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
            if let dict = finalJSON?.dictionaryObject as NSDictionary?
            {
                print("Receive Dict:((\(url))---->\(dict)");
                handlerCompletion(dict);
            }
            else
            {               
                let dict = ["success":false]
                print("FAIL-------------")
                handlerCompletion(dict as NSDictionary)
            }
        }
    }
    
    
    class func call_API_ImageUpload(url:String,param:[String:Any],doc:[(parameter_name:String,data:Data,type:String)],handlerCompletion:@escaping (_ resDict:NSDictionary) -> Void)
    {
        
        print("Send URL:---->\(url)");
        
        print("Send Dict:---->\(param)");
        
        if isConnectedToNetwork() == false
        {
            let dict = ["status":false,"message":"No internet available."] as [String : Any]
            handlerCompletion(dict as NSDictionary)
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for(key,value) in param
            {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            
            
            for media in doc
            {
                if media.type == "image"
                {
                    multipartFormData.append(media.data, withName: media.parameter_name, fileName: "1.png", mimeType: "image/jpeg");
                }
            }
            
            
            
        }, to: URL(string: url)!) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print(progress)
                })
                
                upload.responseJSON { response in
                    
                    let finalJSON = try? JSON(data: response.data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    if let dict = finalJSON?.dictionaryObject! as NSDictionary?
                    {
                        print("Receive Dict:---->\(dict)");
                        handlerCompletion(dict);
                    }
                    else
                    {
                        let dict = ["success":false]
                        handlerCompletion(dict as NSDictionary)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError.localizedDescription);
                break
            }
            
        }
    }
    
    class func isConnectedToNetwork()->Bool{
     
         return NetworkReachabilityManager()!.isReachable
        
        
//        let recForInternet:Reachability = Reachability.init(hostName: "www.google.com");
//        let netInternetStatus:NetworkStatus = recForInternet.currentReachabilityStatus();
//
//        if (!(netInternetStatus == .NotReachable))
//        {
//            return true;
//        }
//        else
//        {
//            return false;
//        }
//
        
    }
}




