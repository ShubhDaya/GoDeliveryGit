//
//  MessageConstant.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 27/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//
//
//  MessageConstant.swift
//  Mualab
//
//  Created by MINDIII on 10/16/17.
//  Copyright © 2017 MINDIII. All rights reserved.
//

import Foundation
import UIKit


//MARK:- validation Alerts
let BlankFirstName: String = "The firstname field is required"
let BlankLastName: String = "The lastname field is required"
let BlankFullName: String = "Please enter Full name"


let MinLengthFirstName: String = "First name should not less than 3 characters"
let MaxLengthFirstName: String = "First name should not greater than 15 characters"

let MinLengthLastName: String = "Last name should not less than 3 characters"
let MaxLengthLastName: String = "Last name should not greater than 15 characters"

let MinLengthUserName: String = "User name should not less than 3 characters"



let BlankEmail: String = "The email field is required"
let InvalidEmail: String = "Please enter valid email"
let BlankPassword: String = "The password field is required"
let BlankNewPassword: String = "The new password field is required"

let BlankOldPassword: String = "The current password field is required"



let BlankConfirmPwd: String = "The confirm password field is required"
let InvalidConfirmPwd: String = "Confirm password does not match"
let BlankDialcode: String = "The country code field is required"

let InvalidPhonenumber: String = "Please enter valid phone number"


let BlankCountry: String = "The country field is required"
let BlankCity: String = "The location field is required"
let BlankProfilePic: String = "Please select image"



let LengthPassword: String = "Please enter password with minimum 6 characters"
let currentPasslenght: String = "Please enter current password with minimum 6 characters"

let InvalidFirstName: String = "Please enter valid first name"
let InvalidLasttName: String = "Please enter valid last name"

let CardHolderName : String = "Please enter your card name"
let CardNumber : String = "Please enter your card number"
let CardExpiryDate : String = "Please enter valid expiry date"
let CardCVV : String = "Please enter your cvv number"
let CardValidationCVV : String = "Please enter the correct cvv number"
let CardValidationHolderName : String = "Card holder name should not less than 3 charcters"
let CardValidationNumber : String = "Please enter the correct card number"
let BankHolderName : String = "Please enter your first name"
let BankHolderLastName : String = "Please enter your last name"
let BankHolderValidationName : String = "First Name should not less than 3 characters"
let BankAccountNumber : String = "Please enter your bank account number"
let BankHolderValidationLastName : String = "Last Name should not less than 3 characters"

//Color constant
let Appcolor = UIColor(red: 205.0 / 255.0, green: 57.0 / 255.0, blue: 105.0 / 255.0, alpha: 1.0)


//MARK:- APi handling Alerts
let kAlertMessage: String = "Message"
let kAlertTitle: String = "Alert"
let k_success = "success"
let k_OK = "Ok"
let k_UnderDevlope = "Under Development"

let k_sessionExpire = "Session expired"
let kErrorMessage: String = "Something went wrong"
let k_noNetwork = "No network"
let k_networkAlert = "Please check your internet connection."
let k_Inactiveuser = "User Inactive"
let k_ChangePassword = "Your password has been updated successfully.please login again."


func checkForNULL(obj:Any?) -> Any {
    return obj ?? ""
}
