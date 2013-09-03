
#import "GWVersion.h"


@implementation GWVersion : NSObject



- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _postDate = [attributes valueForKeyPath:@"postDate"];
    _shortUrl = [attributes valueForKeyPath:@"shortUrl"];
    _url = [attributes valueForKeyPath:@"url"] ;
    _isHide = [[attributes valueForKeyPath:@"isHide"] integerValue];
    _versionMemo = [attributes valueForKeyPath:@"versionMemo"];
    _displayName = [attributes valueForKeyPath:@"displayName"];
    _versionType = [attributes valueForKeyPath:@"versionType"] ;
    [self setAppName:[attributes valueForKey:@"appName"]];
    [self setAppVersion:[[attributes valueForKey:@"appVersion"] description]];
    [self setIconUrl:[attributes valueForKey:@"iconUrl"]];
    [self setUrl_scheme:[attributes valueForKey:@"url_scheme"]];
    
    if ([attributes objectForKey:@"platFormList"]) {
        NSArray *platFormArray = [attributes objectForKey:@"platFormList"];
        _platFormList =[NSMutableArray arrayWithCapacity:[platFormArray count]];
        for (NSDictionary *platFormDic in platFormArray) {
            GoldPlatForm *platForm = [[GoldPlatForm alloc] initWithAttributes:platFormDic];
            [_platFormList addObject:platForm];
        }
    }
    
    return self;
}

+(AFHTTPRequestOperation *) CheckAppInfoOnSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        if (success) {
            GWVersion *version = [[GWVersion alloc]initWithAttributes:json];
            success(version);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestCheckAppInfo parameters:nil];
}

+(AFHTTPRequestOperation *) GetGoldAndExchangeWallOnSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestGetGoldAndExchangeWall parameters:nil];
}



@end