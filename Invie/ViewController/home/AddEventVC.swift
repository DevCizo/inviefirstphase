//
//  AddEventVC.swift
//  Invie
//
//  Created by Hitesh Thummar on 28/09/18.
//  Copyright © 2018 Hitesh Thummar. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class AddEventVC: UIViewController {

    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var lblSelectedEvent: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtEventInput: UITextField!
    @IBOutlet weak var txtEventDetail: KMPlaceholderTextView!
    
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    
    @IBOutlet weak var lblLocTitle: UILabel!
    @IBOutlet weak var txtLocation: KMPlaceholderTextView!
    
    
    @IBOutlet weak var btnCeate: UIButton!
    @IBOutlet weak var CSscrollHeight: NSLayoutConstraint!
    
    
    
    var endDatePickerView:UIDatePicker!
    var months = ["januari",
                  "februari",
                  "maart",
                  "april",
                  "mei",
                  "juni",
                  "juli",
                  "augustus",
                  "september",
                  "oktober",
                  "november",
                  "december"
]
    
    var selectedEvent = -1;
    
    var dateSelected = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionview.delegate = self
        collectionview.dataSource = self
        collectionview.reloadData()
        
        var datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .date
        txtDate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        datePickerView.minimumDate = Date()
        datePickerView.locale = Locale(identifier: "nl")
        
        
        
        datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .time
        txtStartTime.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(startTime(sender:)), for: .valueChanged)
        
        
        endDatePickerView = UIDatePicker()
        endDatePickerView.datePickerMode = .time
        txtEndTime.inputView = endDatePickerView
        endDatePickerView.addTarget(self, action: #selector(endTime(sender:)), for: .valueChanged)
        
        txtEventInput.delegate = self
        
        let lbl = txtDate.value(forKey: "_placeholderLabel") as! UILabel
        lbl.adjustsFontSizeToFitWidth = true
    }

    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MM yyyy"
        var str = dateFormatter.string(from: sender.date)
        let arr = str.components(separatedBy: " ")
        
        if arr.count > 2
        {
            let num = Int("\(arr[1])")
            let getMonth = months[num! - 1]
            str = arr[0] + " " + getMonth + " " + arr[2]
        }
        txtDate.text = str
        
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateSelected = dateFormatter.string(from: sender.date)
        
        
    }
    
    @objc func startTime(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        txtStartTime.text = dateFormatter.string(from: sender.date)
        endDatePickerView.minimumDate = sender.date
    }
    
    @objc func endTime(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        txtEndTime.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    @IBAction func btnCreate(_ sender: UIButton) {
        
        if selectedEvent == -1
        {
            showToastMessage(msg: "Please select Event type.")
            return
        }
        
        if !txtEventInput.text!.isContainText()
        {
            showToastMessage(msg: "Please enter Event name.")
            return
        }
        
        if !txtDate.text!.isContainText()
        {
            showToastMessage(msg: "Please enter Event date.")
            return
        }
        
        
        if !txtStartTime.text!.isContainText()
        {
            showToastMessage(msg: "Please enter Event start time.")
            return
        }
        
        
        if !txtEndTime.text!.isContainText()
        {
            showToastMessage(msg: "Please enter Event start time.")
            return
        }
        
        if !txtLocation.text!.isContainText()
        {
            showToastMessage(msg: "Please enter Event location.")
            return
        }
        
        
        
        if !txtEventDetail.text!.isContainText()
        {
            showToastMessage(msg: "Please enter Event detail.")
            return
        }
        
        
        let param = [
            EVENTTYPE_K:"\(selectedEvent + 1)",
            USERID_K:USERID,
            MESSAGE_K:txtEventDetail.text!,
            "datetime":dateSelected,
            NAME_K:txtEventInput.text!,
            "start_time":txtStartTime.text!,
            "end_time":txtEndTime.text!,
            "location":txtLocation.text!]
        
        showLoader()
        APICall.call_API_ALL(url: API_ADDEVENT, param: param) { (dict) in
            
            if let success = dict.value(forKey: SUCCESS) as? Bool,success == true
            {                
                if let url = dict.value(forKey: "url") as? String
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckEventVC") as! CheckEventVC
                    
                    vc.eventTitle = self.txtEventInput.text!
                    vc.eventType = self.selectedEvent + 1
                    vc.eventDate = self.dateSelected
                    vc.eventUrl = url
                    vc.eventDesc = self.txtEventDetail.text!
                    vc.stime = self.txtStartTime.text!
                    vc.etime = self.txtEndTime.text!
                    vc.location = self.txtLocation.text!
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
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

}

extension AddEventVC:UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text: NSString = (textField.text ?? "") as NSString
        let resultString = text.replacingCharacters(in: range, with: string)
        //lblLocTitle.text = "Waar vind je \(resultString) Plaats?"
        return true
    }
}


extension AddEventVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return EventArray.count;
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventItemTypeCell", for: indexPath) as! EventItemTypeCell
        cell.img.image = UIImage(named: "event\(indexPath.row + 1)" )
        
        if selectedEvent == indexPath.row
        {
            cell.lblName.isHidden = false
        }
        else
        {
            cell.lblName.isHidden = true
        }
        
        cell.lblName.text = EventArray[indexPath.row]
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedEvent = indexPath.row
        collectionView.reloadData()
        lblSelectedEvent.text = "Wanneer is je \(EventArray[indexPath.row])?"
        lblLocTitle.text = "Waar vind je \(EventArray[indexPath.row]) plaats?"
        CSscrollHeight.constant = btnCeate.frame.origin.y + 100
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        let width = (SCREEN_SIZE.width - 50) / 5
        
            return CGSize(width: width , height: width + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 00
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
}


class EventItemTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var img: UIImageView!
    
}







