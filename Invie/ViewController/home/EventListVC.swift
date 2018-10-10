//
//  EventListVC.swift
//  Invie
//
//  Created by Hitesh Thummar on 28/09/18.
//  Copyright © 2018 Hitesh Thummar. All rights reserved.
//

import UIKit

class EventListVC: UIViewController {

    @IBOutlet weak var CSNavHeight: NSLayoutConstraint!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    var noDataMsg = ""
    var refreshControl = UIRefreshControl()
    var eventListArr:[NSDictionary] = []
    var isApiCalling = false
    var noDataFound = false
    
    var BirthDaycolor:[CGColor] = [fromIntToColor(red: 239, green: 102, blue: 171, alpha: 1).cgColor, fromIntToColor(red: 172, green: 45, blue: 245, alpha: 1).cgColor]
  
    var DrinkDinnercolor:[CGColor] = [fromIntToColor(red: 226, green: 116, blue: 152, alpha: 1).cgColor, fromIntToColor(red: 235, green: 202, blue: 170, alpha: 1).cgColor]
    
    var Anniversarycolor:[CGColor] = [fromIntToColor(red: 118, green: 106, blue: 253, alpha: 1).cgColor, fromIntToColor(red: 239, green: 102, blue: 171, alpha: 1).cgColor]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let id = userDict.value(forKey: ID_K)
        {
            USERID = "\(id)"
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "Vernieuwen")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: UIControlEvents.valueChanged)
        tableview.addSubview(refreshControl)
    
        tableview.delegate = self
        tableview.dataSource = self

        if iPhoneX
        {
            CSNavHeight.constant = 170
        }
        callItemAllAPI(isPageRefresh: false, search: "")
        txtSearch.delegate = self
        
        NOTIFICATIONCENTER.addObserver(self, selector: #selector(self.refresh(_:)), name: NSNotification.Name(rawValue: "refreshList"), object: nil)
        
    }

    
        override func viewDidAppear(_ animated: Bool) {
        
    }
   
    @IBAction func btnAddEvent(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddEventVC") as! AddEventVC
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btnEventDetail(_ sender: UIButton) {
        
        
        self.view.endEditing(true)
        
        let dict = eventListArr[sender.tag]
        
        if let id = dict.value(forKey: ID_K)
        {
            let param = ["event_id":"\(id)"]
            
            showLoader()
            APICall.call_API_ALL(url: API_EVENTDETAIL, param: param) { (dict) in
                
                if let success = dict.value(forKey: SUCCESS) as? Bool,success == true
                {
                    if let d = dict.value(forKey: DATA_K) as? NSDictionary
                    {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
                        vc.dataDict = d;
                        self.present(vc, animated: true, completion: nil)
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
            }
        }
    }
    
    @objc func refresh( _ sender:AnyObject) {
      
        noDataFound = false
        callItemAllAPI(isPageRefresh: true, search: txtSearch.text!)
        self.view.endEditing(true)
       
    }
    
    
    
}

extension EventListVC
{
    @objc func callItemAllAPI(isPageRefresh:Bool,search:String)
    {
        var pages = 0;
        if eventListArr.count % 5 == 0
        {
            pages = eventListArr.count / 5;
        }
        else
        {
            pages = (eventListArr.count / 5) + 1;
        }
        if pages == 0 && !refreshControl.isRefreshing
        {
            showLoader()
        }
        
        if isPageRefresh
        {
            pages = 0
        }
        
        if isApiCalling
        {
            return
        }
        
        if noDataFound
        {
            return
        }
        isApiCalling = true
        if userDict != nil
        {
            let param = [USERID_K:USERID,PAGE_K:"\(pages)","page_size":"5","search":search]
            //let param = [USERID_K:"1",PAGE_K:"\(pages)","page_size":"5"]
            
            APICall.call_API_ALL(url: API_EVENTLIST, param: param) { (dict) in
              
                if let success = dict.value(forKey: SUCCESS) as? Bool,success == true
                {
                    if let dictArr = dict.value(forKey: DATA_K) as? [NSDictionary]
                    {
                        if dictArr.count == 0 || dictArr.count < 5
                        {
                            self.noDataFound = true
                        }
                        
                        if pages == 0
                        {
                            self.eventListArr.removeAll()
                        }
                        
                        for d in dictArr
                        {
                            self.eventListArr.append(d)
                        }
                        
                        if let msg = dict.value(forKey: MESSAGE_K),self.noDataMsg == ""
                        {
                            self.noDataMsg = "\(msg)"
                        }
                        
                        self.tableview.reloadData()
                    }
                    
                   
                    
                    
                    if self.refreshControl.isRefreshing
                    {
                        self.refreshControl.endRefreshing()
                    }
                    
                    self.isApiCalling = false
                    if pages == 0
                    {
                        hideLoader()
                    }
                }
                else
                {
                    hideLoader()
                }
            }
        }
    }
}

extension EventListVC:UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventListCell", for: indexPath) as! EventListCell
        
        let dict = eventListArr[indexPath.row]
        
        if let nm = dict.value(forKey: NAME_K)
        {
            cell.lblEvent.text = "\(nm)"
        }
        
        if let go = dict.value(forKey: GOING_K)
        {
            cell.lblGoing.text = "Aanwezig : \(go)"
        }
        
        if let go = dict.value(forKey: NOTGOING_K)
        {
            cell.lblnotgoing.text = "Afwezig     : \(go)"
        }
        
        
        if let dt = dict.value(forKey: DATETIME_K)
        {
            let dateStr = "\(dt)"
            if let date = dateStr.getDateFromStringWith(format: "yyyy-MM-dd")
            {
                cell.lblDay.text = date.weekdayNameDutch
                cell.lblDate.text = date.day
            }
        }
        
        
        if let nm = dict.value(forKey: NAME_K)
        {
            cell.lblEvent.text = "\(nm)"
        }
        
        
        
        cell.btnView.tag = indexPath.row
        cell.btnView.addTarget(self, action: #selector(self.btnEventDetail(_:)), for: .touchUpInside)
        //Set color
        
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: SCREEN_SIZE.width - 40, height: cell.innerBGVw.frame.height)
        
        
        if let eventType = dict.value(forKey: EVENTTYPE_K) as? Int
        {
            switch(eventType)
            {
                case 1:
                layer.colors = BirthDaycolor
                break
             
            case 2:
                layer.colors = Anniversarycolor
                break
         
            case 3:
                layer.colors = DrinkDinnercolor
                break
                
            default:
                layer.colors = DrinkDinnercolor
                break
            }
        }
       
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        cell.innerBGVw.layer.addSublayer(layer)
        
        //Color Over
        
        
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
    
        var numOfSection: NSInteger = 0
        if eventListArr.count > 0
        {
            tableView.backgroundView = nil
            numOfSection = 1
        }
        else
        {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x:20, y:0, width:tableView.bounds.size.width - 40, height:tableView.bounds.size.height))
            noDataLabel.text = noDataMsg
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.numberOfLines = 0
            noDataLabel.lineBreakMode = .byWordWrapping
            noDataLabel.textAlignment = NSTextAlignment.center
            tableView.backgroundView = noDataLabel
        }
        
        return numOfSection
    
    }
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == eventListArr.count - 1
        {
            callItemAllAPI(isPageRefresh: false, search: "")
        }
    }
}

extension EventListVC:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        
        if resultString.count > 0 && resultString.count < 3
        {
            return true
        }
        
        eventListArr.removeAll()
        noDataFound = false
        callItemAllAPI(isPageRefresh: false, search: resultString)
        
        return true
    }
}


class EventListCell: UITableViewCell {
    
    
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblEvent: UILabel!
    
    
    
    @IBOutlet weak var lblGoing: UILabel!
    @IBOutlet weak var lblnotgoing: UILabel!
    
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var innerBGVw: UIView!
    @IBOutlet weak var btnView: UIButton!
    
    override func awakeFromNib() {
        
        //innerView.backgroundColor = .clear
        
      
    }
}


