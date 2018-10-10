//
//  CheckEventVC.swift
//  Invie
//
//  Created by Hitesh Thummar on 29/09/18.
//  Copyright © 2018 Hitesh Thummar. All rights reserved.
//

import UIKit

class CheckEventVC: UIViewController {

    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var imgEvent: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    
    var eventTitle = ""
    var eventDesc = ""
    var eventType = -1
    var eventDate = ""
    var eventUrl = ""
    var stime = ""
    var etime = ""
    var location = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // lblTitle.text = eventTitle
        lblDesc.text = eventDesc
        
        if let myImage = UIImage(named: "eventTrans\(eventType)") {
            imgEvent.image = myImage
        }
        
        
        if let eDate = eventDate.getDateFromStringWith(format: "yyyy-MM-dd")
        {
            let date = eDate.day
            let month = eDate.monthName
            let year = eDate.OnlyYear
            let dayName = eDate.weekdayNameFullDutch
            
            var subStr = ""
            
            switch(date)
            {
            case "1","31":
                    subStr = "st"
                    break;
            case "2":
                subStr = "nd"
                break;
                
            case "3":
                subStr = "rd"
                break;
                
            default:
                    subStr = "th"
                    break
            }

//            with th
//            let fullStr = "\(date)\(subStr) \(month.replacingOccurrences(of: ".", with: "")) \(year), \(dayName)"
//            lblDate.attributedText = setDateWithFormat(dateStr: fullStr,value: [year,date],subStr: subStr)

            
            let fullStr = "\(date) \(month.replacingOccurrences(of: ".", with: "")) \(year), \(dayName)"
            lblDate.attributedText = setDateWithFormat(dateStr: fullStr,value: [year,date],subStr: "")
            
        }
        
        
       lblLocation.text = location
        

    }

    func setDateWithFormat(dateStr:String,value:[String],subStr:String) -> NSMutableAttributedString
    {
        
        let attributedString = NSMutableAttributedString(string: dateStr)
        
        for str in value
        {
            if let range = dateStr.range(of: str)
            {
                let nsrange = str.nsRange(from: range)
                attributedString.addAttributes([NSAttributedStringKey.font: UIFont(name: FONT_POPOINS_SEMIBOLD, size: 20)!], range: nsrange)
            }
        }
        
        if let range = dateStr.range(of: subStr)
        {
            let nsrange = subStr.nsRange(from: range)
             attributedString.addAttributes([NSAttributedStringKey.baselineOffset:8,NSAttributedStringKey.font: UIFont(name: FONT_POPOINS_SEMIBOLD, size: 10)!], range: nsrange)
        }
        
        return attributedString
    }
    @IBAction func shareWhatsApp(_ sender: UIButton) {
        
       // let fulTexr = "Event Name : \(eventTitle) \nEvent Date :  \(eventDate) \nDescription : \(eventDesc) \n\n\(eventUrl)"
        
      
        
        var eventName = EventArray[eventType - 1]
        eventName = eventName.replacingOccurrences(of: "&", with: "en")
        
        
        
        var whatUrl = ""
        if let dateFor = eventDate.getDateFromStringWith(format: "yyyy-MM-dd")
        {
            let month = dateFor.monthFullNameDutch
            let dayname = dateFor.weekdayNameFullDutch
            let day = dateFor.day
            
            
            let arr = stime.components(separatedBy: ":")
            var startTime = ""
            if arr.count > 1
            {
                startTime = arr[0] + ":" + arr[1]
                
            }
            
            whatUrl = "Je bent uitgenodigd voor de \(eventName) op \(dayname) \(day) \(month.replacingOccurrences(of: ".", with: "")) om \(startTime). Bekijk hier de uitnodiging: \(eventUrl) en laat weten of je komt!"
        }
        
        
        
         let ful = "Je bent uitgenodigd voor de \(eventName) op \(eventDate) op \(stime) naar \(etime). Bekijk hier de uitnodiging: \(eventUrl) en laat weten of je komt!"
        
        
       // let fulTexr = "Je bent uitgenodigd voor het \(eventName).\nBekijk hier het evenement: \(eventUrl) Tot snel."
        
        let urlWhats = "whatsapp://send?text=\(whatUrl)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL, options: [:]) { (bool) in
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.btnBack(sender)
                        
                    })
                    
                    
                    
                    
                
                } else {
                    
                    let alert = UIAlertController(title: NSLocalizedString("Whatsapp not found", comment: "Error message"),
                                                  message: NSLocalizedString("Could not found a installed app 'Whatsapp' to proceed with sharing.", comment: "Error description"),
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Alert button"), style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
                    }))
                    
                    self.present(alert, animated: true, completion:nil)
                    // Cannot open whatsapp
                }
            }
        }
        
    }
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        NOTIFICATIONCENTER.post(name: NSNotification.Name(rawValue: "refreshList"), object: nil)

    }
    

}
