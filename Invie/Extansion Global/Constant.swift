//
//  Constant.swift

//
//  Created by Hitesh Thummar on 29/01/18.
//  Copyright © 2018 Hitesh Thummar. All rights reserved.
//

import UIKit




var userDict:NSDictionary!
var USERID = ""

var EventArray:[String] = ["Verjaardag","Drankjes & Diner","Thema-evenement","Afspraak","speciaal event"]



let FONT_POPOINS_REGULAR = "Poppins-Regular"
let FONT_POPOINS_BOLD = "Poppins-Bold"
let FONT_POPOINS_SEMIBOLD = "Poppins-SemiBold"

let SCREEN_SIZE = UIScreen.main.bounds;
let NOTIFICATIONCENTER = NotificationCenter.default;
let USERDEFAULTS = UserDefaults.standard;

let COLOR_PINK = "FB6882"



let is_Ipad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)

let iPhone4 = UIScreen.main.sizeType == .iPhone4
let iPhone5_SE = UIScreen.main.sizeType == .iPhone5_Se
let iPhone6_6s_7_8 = (UIScreen.main.sizeType == .iPhone6_6s_7_8)
let iPhone6_6s_7_8_Plus = (UIScreen.main.sizeType == .iPhone6_6s_7_8_Plus)
let iPhoneX = (UIScreen.main.sizeType == .iPhoneX_XS)
let iPhoneXR = (UIScreen.main.sizeType == .iPhoneXR)
let iPhoneXS_MAX = (UIScreen.main.sizeType == .iPhoneXS_MAX)
let IphoneWithNotch  =  (iPhoneX || iPhoneXR || iPhoneXS_MAX)

