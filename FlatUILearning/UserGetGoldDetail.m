//
//  UserGetGoldDetail.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-4.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "UserGetGoldDetail.h"

@implementation UserGetGoldDetail

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    if (![attributes isKindOfClass:[NSDictionary class]]) return self;
    
    _udid=[attributes objectForKey:@"udid"];
    _gid=[[attributes objectForKey:@"gid"] intValue];
    _postDate=[attributes objectForKey:@"postDate"];
    _goldAmount=[[attributes objectForKey:@"goldAmount"] intValue];
    _pCnName=[attributes objectForKey:@"pCnName"];
    _pid=[[attributes objectForKey:@"pid"] intValue];
    _meno=[attributes objectForKey:@"meno"];
    return self;
}
+(AFHTTPRequestOperation *) getUserGetGoldLogOnSuccess:(void (^)(id))success failure:(void (^)(id))failure pageNo:(int) pageNo{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        if (success) {
            NSMutableArray *mutableArray=[NSMutableArray arrayWithCapacity:[json count]];
            for (NSDictionary *attribute in json) {
                UserGetGoldDetail *goldLog=[[UserGetGoldDetail alloc] initWithAttributes:attribute];
                [mutableArray addObject:goldLog];
            }
            success(mutableArray);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestUserGetGoldLogLog(APPDELEGATE.udid,pageNo) parameters:nil];
}
@end
