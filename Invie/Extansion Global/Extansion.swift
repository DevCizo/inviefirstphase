//
//  Global.swift
//  Sample App
//
//  Created by Hitesh Thummar on 14/07/18.
//  Copyright © 2018 Hitesh Thummar. All rights reserved.
//

//https://stackoverflow.com/questions/9388372/how-to-show-an-activity-indicator-in-sdwebimage


import UIKit
import Toaster
import SVProgressHUD




extension String {

    func isContainText() -> Bool
    {
        return self.trimmingCharacters(in: .whitespaces) == "" ? false : true
    }
    
}
    


func fromIntToColor(red:Int,green:Int,blue:Int,alpha:CGFloat) ->UIColor
{
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
}


func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}


extension UITextField {
    func setFontSize (size:Int) {
        self.font =  UIFont(name: self.font!.fontName, size:CGFloat(size))!
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}

extension UILabel {
    func setFontSize (size:Int) {
        self.font =  UIFont(name: self.font!.fontName, size:CGFloat(size))!
    }
    
    func addCharactersSpacing(_ value: CGFloat = 1.5) {
        if let textString = text {
            let attrs: [NSAttributedStringKey : Any] = [.kern: value]
            attributedText = NSAttributedString(string: textString, attributes: attrs)
        }
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: FONT_POPOINS_BOLD, size: 11)!,.foregroundColor:UIColor(hex: COLOR_PINK, alpha: 1)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}


//MARK: -device type
extension UIScreen {
    
    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5_Se = 1136.0
        case iPhone6_6s_7_8 = 1334.0
        case iPhone6_6s_7_8_Plus = 2208.0
        case iPhoneX_XS = 2436.0
        case iPhoneXR = 1792.0
        case iPhoneXS_MAX = 2688.0
        
    }
    
    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
    
    /*
     if UIScreen.main.sizeType == .iPhoneX
     {}
     */
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

//MARK:- UIColor
extension UIColor {
    convenience init(hex: String,alpha:CGFloat) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: alpha
        )
    }
}

//MARK:- toster

func showToastMessage(msg:String)
{
    Toast(text: msg).show()
}
//MARK:- Blur
extension UIView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            blurView.removeFromSuperview()
        }
    }
}

//MARK:- Loader

func showLoader()
{
    SVProgressHUD.show()
    UIApplication.shared.beginIgnoringInteractionEvents()
}

func hideLoader()
{
    UIApplication.shared.endIgnoringInteractionEvents()
    DispatchQueue.main.async(execute: {() -> Void in
        SVProgressHUD.dismiss()
    })
}



func saveUserData(dict:NSDictionary)
{
    if let mobile = dict.value(forKey: MOBILE_K)
    {
        USERDEFAULTS.setValue("\(mobile)", forKey: MOBILE_K)
    }
    
    if let name = dict.value(forKey: NAME_K)
    {
        USERDEFAULTS.setValue("\(name)", forKey: NAME_K)
    }
    
    if let id = dict.value(forKey: ID_K)
    {
        USERDEFAULTS.setValue("\(id)", forKey: ID_K)
    }
    
    USERDEFAULTS.setValue("1", forKey: ISLOGIN_K)
    
    USERDEFAULTS.synchronize()
    
}



extension UILabel
{
    func addImage(imageName: String, afterLabel bolAfterLabel: Bool = false)
    {
        let attachment: NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
        
        if (bolAfterLabel)
        {
            let strLabelText: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            strLabelText.append(attachmentString)
            
            self.attributedText = strLabelText
        }
        else
        {
            let strLabelText: NSAttributedString = NSAttributedString(string: self.text!)
            let mutableAttachmentString: NSMutableAttributedString = NSMutableAttributedString(attributedString: attachmentString)
            mutableAttachmentString.append(strLabelText)
            
            self.attributedText = mutableAttachmentString
        }
    }
    
    func removeImage()
    {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}



extension String {
    func getDateFromStringWith(format:String) -> Date? {
        
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFmt.dateFormat =  format
        // Get NSDate for the given string
        return dateFmt.date(from: self)
        
    }
}

extension Date {
    
    var weekdayName: String {
        let formatter = DateFormatter(); formatter.dateFormat = "E"
        return formatter.string(from: self as Date)
    }
    
    var weekdayNameDutch: String {
        let formatter = DateFormatter(); formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "nl")
        return formatter.string(from: self as Date)
    }
    
    
    var day: String {
        let formatter = DateFormatter(); formatter.dateFormat = "dd"
        return formatter.string(from: self as Date)
    }
    
    var weekdayNameFull: String {
        let formatter = DateFormatter(); formatter.dateFormat = "EEEE"
        return formatter.string(from: self as Date)
    }
    
    var weekdayNameFullDutch: String {
        let formatter = DateFormatter(); formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "nl")
        return formatter.string(from: self as Date)
    }
    
    var monthName: String {
        let formatter = DateFormatter(); formatter.dateFormat = "MMM"
        formatter.locale = Locale(identifier: "nl")
        return formatter.string(from: self as Date)
    }
    var monthFullName: String {
        let formatter = DateFormatter(); formatter.dateFormat = "MMM"
        return formatter.string(from: self as Date)
    }
    
    var monthFullNameDutch: String {
        let formatter = DateFormatter(); formatter.dateFormat = "MMM"
        formatter.locale = Locale(identifier: "nl")
        return formatter.string(from: self as Date)
    }
    
    var OnlyYear: String {
        let formatter = DateFormatter(); formatter.dateFormat = "YYYY"
        return formatter.string(from: self as Date)
    }
    var period: String {
        let formatter = DateFormatter(); formatter.dateFormat = "a"
        return formatter.string(from: self as Date)
    }
    var timeOnly: String {
        let formatter = DateFormatter(); formatter.dateFormat = "hh : mm"
        return formatter.string(from: self as Date)
    }
    var timeWithPeriod: String {
        let formatter = DateFormatter(); formatter.dateFormat = "hh : mm a"
        return formatter.string(from: self as Date)
    }
    
    var DatewithMonth: String {
        let formatter = DateFormatter(); formatter.dateStyle = .medium ;        return formatter.string(from: self as Date)
    }
}
