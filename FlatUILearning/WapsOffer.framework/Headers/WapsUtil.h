#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <UIKit/UIKit.h>

//#define WAPX_HOST                       @"http://ios.wapx.cn"
//#define WAPS_HOST                       @"http://ios.waps.cn"
//#define WAPX_HOST_NOHTTP                @"ios.wapx.cn"
//#define WAPS_HOST_NOHTTP                @"ios.waps.cn"
#define WAPX_HOST_TEST                  @"http://219.234.85.151:82"
#define WAPX_HOST_TEST_HOHTTP           @"219.234.85.151:82"

#define WAPX_HOST                       @"http://219.234.85.151:82"
#define WAPS_HOST                       @"http://219.234.85.151:82"
#define WAPX_HOST_NOHTTP                @"219.234.85.151:82"
#define WAPS_HOST_NOHTTP                @"219.234.85.151:82"

#define WAPS_URL_OFFERLIST              @"/ios/offer/list"
#define WAPS_URL_GROUPBUY               @"/ios/tuan/list"

#define WAPS_TUAN_HOST                  @"http://tuan.wapg.cn"

#define WAPS_URL_CONNECT                @"/ios/connect/active"
#define WAPS_URL_UPDATE                 @"/ios/app/update"
#define WAPS_URL_INSTALLED              @"/ios/install/apps_installed"
#define WAPS_URL_INSTALL_INFO           @"/ios/install/install_info"
#define WAPS_URL_PUBLISHER              @"/ios/user/set_publisher_user_id"
#define WAPS_GET_AD_INFO                @"/ios/receiver/checkActivate"
//#define WAPS_GET_AD_ACTIVE            @"/ios/receiver/active"
#define WAPS_GET_AD_ACTIVE              @"/ios/receiver/jailbreak_active"
//#define WAPS_GET_AD_ACTIVE            @"/ios/receiver/active"
#define WAPS_GET_SILENT_AD_ACTIVE       @"/ios/receiver/silent_active"
#define WAPS_URL_GETINFO                @"/ios/points/getinfo"
#define WAPS_URL_SPEND                  @"/ios/points/spend"
#define WAPS_URL_AWARD                  @"/ios/points/award"
#define WAPS_URL_ADSHOW                 @"/ios/ad/show"
#define WAPS_URL_BANNER                 @"/ios/banner/show"
#define WAPS_URL_POPAD                  @"/ios/pop_ad/ad"
#define WAPS_INFO_PLIST                 @"Info_temp.plist"
#define MY_MAIL                         @"kingxiaoguang@gmail.com"

@interface WapsUtil : NSObject {
    int primaryColorCode_;
    UIColor *userDefinedColor_;
}

+ (NSString *)appendGenericParamsWithURL:(NSString *)theURL;

+ (NSString *)revertUrl:(NSString *)url;

+ (NSString *)escapeUrl:(NSString *)url;

+ (NSString *)stringByDecodingURLFormat:(NSString *)string;

+ (BOOL)caseInsenstiveCompare:(NSString *)str1 AndString2:(NSString *)str2;

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;

+ (id)initWithBase64EncodedString:(NSString *)string;

+ (NSString *)encodeBase64WithString:(NSString *)strData;

+ (NSData *)decodeBase64WithString:(NSString *)strBase64;

+ (NSMutableDictionary *)getQueryStringParams:(NSString *)queryString;

+ (NSMutableData *)getQueryStringParamsFroNSData:(NSString *)queryString;

+ (NSString *)getSchemeURL:(NSString *)schemeString;

+ (NSString *)getSchemeID:(NSString *)schemeString;

+ (NSString *)getSchemeName:(NSString *)schemeString;

+ (BOOL)isPad;

+ (NSString *)getShortScheme:(NSString *)schemeString;

+ (NSString *)getCacheDir;

+ (BOOL)clearCacheDir;

+ (NSString *)saveCacheData:(NSData *)data toFile:(NSString *)fileName;

+ (BOOL)fileExitWith:(NSString *)fileName;

+ (NSData *)readDataWithFile:(NSString *)fileName;

+ (void)saveImageAsyncWithUrl:(NSString *)url_ fileName:(NSString *)name_;

+ (void)saveImageWithUrl:(NSString *)url_ fileName:(NSString *)name_;

+ (id)loadImageWithName:(NSString *)name;

+ (id)loadImageWithName:(NSString *)name elseUrl:(NSString *)url;

+ (NSString *)appendingCacheStrWith:(NSString *)str toFile:(NSString *)fileName;

+ (NSString *)readCacheStrWith:(NSString *)fileName;

+ (NSString *)createQueryStringFromString:(NSString *)string;

+ (NSString *)getURLWithParams:(NSString *)url_;

+ (void)clickActionWith:(NSString *)clickURL_ controller:(UIViewController *)baseController forceShow:(BOOL)flg;

+ (void)clickActionWith:(NSString *)clickURL_ controller:(UIViewController *)baseController;

+ (void)silentWith:(NSString *)url_;

+ (NSString *)getAppStoreAccountInfo;

+ (NSString *)encodeToPercentEscapeString:(NSString *)input;

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input;

+ (BOOL)isIOS7;

+ (NSArray *)json2menu:(NSString*)jsonStr;

+ (NSString *)encryptWithText:(NSString *)sText;

+ (NSString *)decryptWithText:(NSString *)sText;

+ (NSString *)getCacheObjectForKey:(NSString *)defaultName;

+ (void)setCacheObject:(NSString *)value forKey:(NSString *)defaultName;

+ (void)removeCacheObjectForKey:(NSString *)defaultName;


+ (void)testView:(UIView *) rootViews space:(NSString *) space;


@end
