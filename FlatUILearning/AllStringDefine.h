//
//  NSObject_AllStringDefine.h
//  FlatUILearning
//
//  Created by gang zeng on 13-6-19.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//
  
//APP
#define APP_NAME @"GuaGuaLe"
#define VERSION_STRING @"1.10"

//McDonald 版本 1.00 appStroe 1.01 91市场  1.02 测试版
#define APPNAME_MCDONALD @"McDonald"
//GuaGuale 刮刮乐 1.10 appStroe 1.11 91市场  1.12 测试版
#define APPNAME_GUAGUALE @"GuaGuaLe"
//#define VERSION 1.0

//麦当劳优惠劵 
#define APP_FIRST_TAB_NAME @"全民刮刮乐"


#define PRIVATE_SECRET_KEY @"javababyzenggang"
 
//Base View
#define mainScreenHeight [UIScreen mainScreen].bounds.size.height

#define mainScreenHeightWithoutBar [UIScreen mainScreen].bounds.size.height-64

#define mainTableViewHeight [UIScreen mainScreen].bounds.size.height-20

#define mainScreenWidth [UIScreen mainScreen].bounds.size.width

#define keyWindowHeight [UIApplication sharedApplication].keyWindow.bounds.size.height

#define appMainWindow  [UIApplication sharedApplication].keyWindow

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)


// API
#define kRequestMethodGet               @"GET"
#define kRequestMethodPut               @"PUT"
#define kRequestMethodPost              @"POST"
#define kRequestMethodPatch             @"PATCH"
#define kRequestMethodDelete            @"DELETE"
 

//Urls
//#define BaseUrl @"http://121.199.42.54:8080/gold"
#define BaseUrl @"http://192.168.1.100:8080/gold" 
//#define BaseUrl @"http://192.168.1.105:8080/gold"

#define KRequestMenuPicUrl(url) [NSString stringWithFormat:@"http://www.mcdonalds.com.cn/images/mclub/%@",url]

#define KRequestLatestMenu  [NSString stringWithFormat:@"%@/api/version/getMcdonaldsData",BaseUrl]

#define KRequestFindNearbyRestaurant(lat,lng) [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&sensor=false&language=zh-CN&radius=10000&keyword=mcdonalds&key=AIzaSyDJXuyKYYqUiSvGLmWxXRX0NL6xd8qmnfc",lat,lng]

#define GOLDRequestCheckUser(udid,deviceToken) [NSString stringWithFormat:@"%@/api/Users/checkUser/%@?deviceToken=%@",BaseUrl,udid,deviceToken ? deviceToken : @""]
#define GOLDRequestCreateUser(udid) [NSString stringWithFormat:@"%@/api/Users/createUser/%@",BaseUrl,udid]

#define GOLDRequestAddGold(udid,data,secretKey) [NSString stringWithFormat:@"%@/api/UserGold/addGold/%@?data=%@&secretKey=%@",BaseUrl,udid,data,secretKey]
#define GOLDRequestDeductingGoldGold(udid,data) [NSString stringWithFormat:@"%@/api/UserGold/deductingGold/%@?data=%@",BaseUrl,udid,data]

#define GOLDRequestSynchroGold(udid,data) [NSString stringWithFormat:@"%@/api/UserGold/synchroGold/%@?data=%@",BaseUrl,udid,data]
#define GOLDRequestGifGold(udid) [NSString stringWithFormat:@"%@/api/UserGold/userGiftGold/%@",BaseUrl,udid]
#define GOLDWEINXINGShareAwardGold(udid) [NSString stringWithFormat:@"%@/api/UserGold/weixinShareAward/%@",BaseUrl,udid]

#define GOLDRequestUserExchangeLog(udid,pageNo) [NSString stringWithFormat:@"%@/api/GoldExchange/userExchangeLog/%@?pageNo=%d",BaseUrl,udid,pageNo]

#define GOLDRequestExchangeTypes [NSString stringWithFormat:@"%@/api/GoldExchange/exchangeTypes",BaseUrl]
#define GOLDRequestExchangeGold(udid) [NSString stringWithFormat:@"%@/api/GoldExchange/%@",BaseUrl,udid]

#define GOLDRequestUserGetGoldLogLog(udid,pageNo) [NSString stringWithFormat:@"%@/api/UserGold/getGoldLog/%@?pageNo=%d",BaseUrl,udid,pageNo]

#define GOLDRequestChangeExchangeNumberInfo(udid) [NSString stringWithFormat:@"%@/api/Users/changeUserExchangeNumber/%@",BaseUrl,udid]

#define GOLDRequestBindingQQ(udid,qq) [NSString stringWithFormat:@"%@/api/Users/bandqq/%@?qq=%@",BaseUrl,udid,qq]
#define GOLDRequestQqAward(udid,qq) [NSString stringWithFormat:@"%@/api/Users/qqAward/%@?qq=%@",BaseUrl,udid,qq] 

#define GOLDRequestCheckAppInfo [NSString stringWithFormat:@"%@/api/version/checkAppInfo",BaseUrl] 
#define GOLDRequestGetGoldAndExchangeWall [NSString stringWithFormat:@"%@/api/version/getGoldAndExchangeWall",BaseUrl]  

//NSUserdefaults property key name
#define defaults_latest_menu_date @"default_latest_menu_date" 

#pragma mark -
#pragma mark UI ==================================================

#define UI_SET_MENU_PLACEHOLDER_IMAGE [UIImage imageNamed:@"menu_set_image"]

//Notification String
#define NEW_MENU_UPDATE_SUCCESS @"new_menu_update_success"

#define USER_IS_FIRST_LOGIN @"user_is_first_login"
#define USER_CREATED_SUCCESS @"user_created_success"
#define APPINFO_DID_LOADED @"appinfo_did_loaded"

#define CHANGE_VIEW_TO_IDENTIFIER @"changeViewToIdentifier"

#define STRING_ARRAY_FOR_WALL_LOADED @"string_array_for_wall_loaded"

//weixin notify
#define WEI_XIN_DID_RETURN @"wei_xin_did_return"
#define WEI_XIN_OAuth_DID_RETURN @"wei_xin_oAuth_did_return"

