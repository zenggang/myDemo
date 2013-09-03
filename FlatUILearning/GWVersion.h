
#import <Foundation/Foundation.h>
#import "GoldPlatForm.h"

@interface GWVersion : NSObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *postDate;
@property (nonatomic, strong) NSString *shortUrl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *versionMemo;
@property (nonatomic, strong) NSString *versionType;
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *url_scheme;
@property (nonatomic,assign) int isHide;
@property (nonatomic,strong) NSMutableArray *platFormList;

- (id)initWithAttributes:(NSDictionary *)attributes;
+(AFHTTPRequestOperation *) CheckAppInfoOnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
+(AFHTTPRequestOperation *) GetGoldAndExchangeWallOnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
@end