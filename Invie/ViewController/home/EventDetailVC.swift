//
//  EventDetailVC.swift
//  Invie
//
//  Created by Hitesh Thummar on 29/09/18.
//  Copyright © 2018 Hitesh Thummar. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController {

    
    @IBOutlet weak var CSScrollMainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var CSBackHeight: NSLayoutConstraint!
    
    @IBOutlet weak var CSNavHeight: NSLayoutConstraint!
    @IBOutlet weak var lastViewInScroll: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var CSTableHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var lblGoing: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblNotGoing: UILabel!
    @IBOutlet weak var imgEvent: UIImageView!
    
    var dataDict:NSDictionary!
    var nameArr:[NSDictionary] = []
    var noDataMsg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
      
        
        
        
        if let go = dataDict.value(forKey: GOING_K)
        {
            lblGoing.text = "\(go)"
        }
        
        if let go = dataDict.value(forKey: NOTGOING_K)
        {
            lblNotGoing.text = "\(go)"
        }
        
        if let name = dataDict.value(forKey: NAME_K)
        {
            lblName.text = "\(name)"
        }
        
        if let name = dataDict.value(forKey: "list_message")
        {
            noDataMsg = "\(name)"
        }
        
        if let event = dataDict.value(forKey: EVENTTYPE_K) as? Int
        {
            lblName.text = lblName.text! + "(\(EventArray[event - 1]))"
            
            if let myImage = UIImage(named: "eventTrans\(event)") {
                imgEvent.image = myImage
            }
        }
        
        if let list = dataDict.value(forKey: "list") as? [NSDictionary]
        {
            nameArr = list
        }
        tableview.reloadData()
        CSTableHeight.constant = CGFloat(30 * nameArr.count)
        
        if nameArr.count == 0
        {
                CSTableHeight.constant = 50
        }
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.CSScrollMainViewHeight.constant = self.lastViewInScroll.frame.origin.y + 0
        })        
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func shareWhatsApp(_ sender: UIButton) {
        
        
        var name = ""
        var date = ""
        var msg = ""
        var share_url = ""
        var event = -1
        var stime = ""
        var etime = ""
        
        
        if let nm = dataDict.value(forKey: NAME_K)
        {
            name = "\(nm)"
        }
        
        if let dt = dataDict.value(forKey: DATETIME_K)
        {
            date = "\(dt)"
        }
        
        if let ms = dataDict.value(forKey: MESSAGE_K)
        {
            msg = "\(ms)"
        }
        
        if let urlS = dataDict.value(forKey: "share_url")
        {
            share_url = "\(urlS)"
        }
        
        
        if let et = dataDict.value(forKey: EVENTTYPE_K)
        {
            event = Int("\(et)")!
        }
        
        
        if let et = dataDict.value(forKey: STARTTIME_K)
        {
            stime = "\(et)"
        }
        if let et = dataDict.value(forKey: ENDTIME_K)
        {
            etime = "\(et)"
        }
//
        
       
        
        
        
        
        var eventName = EventArray[event - 1]
        eventName = eventName.replacingOccurrences(of: "&", with: "en")
        
        // set date format
        
        var whatUrl = ""
        if let dateFor = date.getDateFromStringWith(format: "yyyy-MM-dd")
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
            
            whatUrl = "Je bent uitgenodigd voor de \(eventName) op \(dayname) \(day) \(month.replacingOccurrences(of: ".", with: "")) om \(startTime). Bekijk hier de uitnodiging: \(share_url) en laat weten of je komt!"
        }
        
        
        
        let ful = "Je bent uitgenodigd voor de \(eventName) op \(date) op \(stime) naar \(etime). Bekijk hier de uitnodiging: \(share_url) en laat weten of je komt!"

       // share_url = share_url.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)!

        
      //  let fulTexr = "Je bent uitgenodigd voor het \(eventName).\nBekijk hier het evenement:\n \(share_url)\n Tot snel."
        

        
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
    
}


extension EventDetailVC:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserComeCell", for: indexPath) as! UserComeCell
        
        let dict = nameArr[indexPath.row]
        
        if let nm = dict.value(forKey: NAME_K)
        {
            cell.lblName.text = "\(nm)"
        }
        
        if let vote = dict.value(forKey: "vote")
        {
            if "\(vote)" == "1"
            {
                cell.imgSign.image = #imageLiteral(resourceName: "greenTrue")
            }
            else
            {
                cell.imgSign.image = #imageLiteral(resourceName: "redX")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        
        var numOfSection: NSInteger = 0
        if nameArr.count > 0
        {
            tableView.backgroundView = nil
            numOfSection = 1
        }
        else
        {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:tableView.bounds.size.width, height:tableView.bounds.size.height))
            noDataLabel.text = noDataMsg
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.numberOfLines = 0
            noDataLabel.lineBreakMode = .byWordWrapping
            noDataLabel.textAlignment = NSTextAlignment.center
            tableView.backgroundView = noDataLabel
        }
        
        return numOfSection
        

    }
    
    
    
}


class UserComeCell: UITableViewCell {
    
    @IBOutlet weak var imgSign: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}
