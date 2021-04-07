//  webserviceConstants.swift
//  LightGeneration
//  Created by mindiii on 10/30/17.
//  Copyright © 2017 mindiii. All rights reserved.

import Foundation

//let BASE_URL = "https://dev.godeliveryplus.com/" //Dev
let BASE_URL = "https://www.godeliveryplus.com/" //live
var kServerKey : String = ""

// Api Base url with api name
struct WsUrl {
    
    static let signup               = BASE_URL + "api/v1/auth/customer/signup"
    static let DeliveryPersonSignUp               = BASE_URL + "api/v1/auth/delivery-person/signup"
    static let login                = BASE_URL + "api/v1/auth/login"
    static let EmailVerifyCheck     = BASE_URL + "api/v1/user/check-email-verification?"
    static let EmailVerifyResend     = BASE_URL + "api/v1/user/resend-verification-email?"

    static let ResetPassword   = BASE_URL + "api/v1/auth/reset-password"
    static let generalList    = BASE_URL + "api/v1/general/list?"
    static let getDelivery    = BASE_URL + "api/v1/delivery"
    static let myprofile    = BASE_URL + "api/v1/user/my-profile"
    static let GetListDelivery    = BASE_URL + "api/v1/delivery?"
    static let qoutDetails    = BASE_URL + "api/v1/delivery/"
    static let quoteAction    = BASE_URL + "api/v1/delivery/quote-action"
    static let trackList    = BASE_URL + "api/v1/delivery/track?"
    static let UpdateProfile    = BASE_URL + "api/v1/user/customer-profile-update"
    static let checkUsernameAvailability   = BASE_URL + "api/v1/auth/username-available?"
    static let getCategoryList   = BASE_URL + "api/v1/general/list"
    static let getExcercise   = BASE_URL + "api/v1/exercise/search?"
    static let giveFeedback   = BASE_URL + "api/v1/exercise/experience"
    static let giveServey   = BASE_URL + "api/v1/user/survey"
    static let addFavorite   = BASE_URL + "api/v1/library/favorite-exercise/"
    static let HistoryList   = BASE_URL + "api/v1/library/exercise-history?"
    static let favoriteList   = BASE_URL + "api/v1/library/favorite-exercise?"
    static let HistoryDetails   = BASE_URL + "api/v1/library/exercise-history-detail/"
    static let favoriteDetails   = BASE_URL + "api/v1/library/favorite-exercise-detail/"
    static let RemoveFromHistory   = BASE_URL + "api/v1/library/exercise-history/"
    static let giveFeedBack   = BASE_URL + "api/v1/exercise/feedback"
    static let clearHistory   = BASE_URL + "api/v1/library/exercise-history/clear"
    static let deleteAccount   = BASE_URL + "api/v1/user?password="
    static let socialSignIN   = BASE_URL + "api/v1/auth/social-signup"
   // static let checkSocialSign   = BASE_URL + "api/v1/auth/check-social-signup"
    static let GiveReview   = BASE_URL + "api/v1/delivery/review"
    static let ChangeReview   = BASE_URL + "api/v1/user/change-password"
    static let SocialSignUp   = BASE_URL + "api/v1/auth/customer/social-signup"
    static let DeliveryPersonSocialSignUp   = BASE_URL + "api/v1/auth/delivery-person/social-signup"

    static let CheckSocialStatus   = BASE_URL + "api/v1/auth/social-status"
    static let AppLaunch   = BASE_URL + "api/v1/general/app-launch?"
    static let NotificatioChangeStatus   = BASE_URL + "api/v1/alert/settings/"
    static let logout   = BASE_URL + "api/v1/auth/logout?"
    static let AlertList   = BASE_URL + "api/v1/alert?"
    static let ReadNotification   = BASE_URL + "api/v1/alert/read/"
    static let ReviewList   = BASE_URL + "api/v1/user/reviews?"
    
    // Delivery person -
    
    static let UploadDocs   = BASE_URL + "api/v1/user/upload-biz-doc"
    static let DeliveryPersonInfo   = BASE_URL + "api/v1/user/delivery-public-profile?"
    static let SkipOnboarding   = BASE_URL + "api/v1/user/skip-onboarding-step/"
    static let DeleteBizDoc   = BASE_URL + "api/v1/user/biz-doc/"
    static let uploadContract   = BASE_URL + "api/v1/user/upload-contract-doc"
    static let ChecApprovedProfileStatus   = BASE_URL + "api/v1/user/check-profile-approval"
    static let AvailablityChangeStatus   = BASE_URL + "api/v1/user/availability/"
    static let NewOrder   = BASE_URL + "api/v4/delivery/new-order"
    static let TrackOrder   = BASE_URL + "api/v1/delivery/track-order/"
    static let deliveryAction   = BASE_URL + "api/v1/delivery/action"
    static let UpdateVehicleInfo   = BASE_URL + "api/v1/user/update-vehicle-info"
    static let CompleteOrder   = BASE_URL + "api/v1/delivery/completed-orders?"
    static let CompleteOrderDetail   = BASE_URL + "api/v1/delivery/"
    static let AskForReview   = BASE_URL + "api/v1/delivery/ask-for-review/"
    static let DeliveryPersonUpdateProfile    = BASE_URL + "api/v1/user/delivery-profile-update"

    }

//Api Header
struct WsHeader {
    //Login
    static let deviceId = "Device-Id"
    static let deviceType = "Device-Type"
    static let deviceTimeZone = "Timezone"
    static let ContentType = "Content-Type"
}

//Api parameters
struct WsParam {
    
    //Signup/Login
    static let offset = "offset"
    static let limit = "limit"
    static let status = "status"

    static let user_firstName = "first_name"
    static let user_lastName = "last_name"
    static let user_MiddleName = "middle_name"
    static let email = "email"
    static let user_type = "user_type"
    static let Authorization = "auth_token"
    static let user_id = "user_id"
    static let DeliverPersonUserId = "userid"

    static let from_location = "from_location"
    static let to_location = "to_location"
    static let from_latitude = "from_latitude"
    static let to_latitude = "to_latitude"
    static let from_longitude = "from_longitude"
    static let to_longitude = "to_longitude"
    static let length = "length"
    static let height = "height"
    static let width = "width"
    static let length_unit = "length_unit"
    static let height_unit = "height_unit"
    static let weight_unit = "weight_unit"
    static let width_unit = "width_unit"
    static let weight = "weight"
    static let description = "description"
    static let delivery_date = "delivery_date"
    static let delivery_time = "delivery_time"
    static let photo = "photo"
    static let delivery_type = "delivery_type"
    static let id = "id"
    static let delivery_type_id = "delivery_type_id"
    static let action = "action"
    static let delivery_id = "delivery_id"
    static let phone_dialCode = "phone_dial_code"
    static let country_code = "phone_country_code"
    static let phone_number = "phone_number"
    static let password = "password"
    static let confirm_password = "confirm_password"
    static let firebase_token = "firebase_token"
    static let social_id = "social_id"
    static let social_type = "social_type"
    static let profilepicture = "profile_picture"
    static let rating = "rating"
    static let review = "review"
    static let is_email_manually_added = "is_email_manually_added"
    static let payment_nonce = "payment_nonce"
    static let amount = "amount"
    static let city = "country"
    static let country = "country"
    static let location = "location"
    static let latitude = "latitude"
    static let longitude = "longitude"
    
// change password -
    static let current_password = "current_password"
    static let new_password = "new_password"

// Deliverperson -
    
    static let type = "type"
    static let file = "file"
    static let current_step_number = "current_step_number"
    static let is_onboarding = "is_onboarding"
    static let make = "make"
    static let model = "model"
    static let plate_number = "plate_number"
    static let color = "color"
}

//Api check for params
struct WsParamsType {
    
    static let PathVariable = "Path Variable"
    static let QueryParams = "Query Params"
    
}
