//
//  GuaGuaKaLog.m
//  FlatUILearning
//
//  Created by gang zeng on 13-9-26.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GuaGuaKaLog.h"

@implementation GuaGuaKaLog


- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _logId =[[attributes objectForKey:@"id"] integerValue];
    _udid =[attributes objectForKey:@"udid"] ;
    _gid =[[attributes objectForKey:@"gid"] integerValue];
    _postDate =[attributes objectForKey:@"postDate"];
    _resultValue=[[attributes objectForKey:@"resultValue"] integerValue];
    _benjin=[[attributes objectForKey:@"benjin"] integerValue];
    _appVersion =[[attributes objectForKey:@"appVersion"] doubleValue];
    
    return self;
}

+(AFHTTPRequestOperation *) getGuaGuaKaLogWithPageNo:(int) pageNo OnSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        
        NSMutableArray *list =[NSMutableArray arrayWithCapacity:[json count]];
        if (success) {
            for (NSDictionary *temp in json) {
                GuaGuaKaLog *log =[[GuaGuaKaLog alloc] initWithAttributes:temp];
                [list addObject:log];
            }
            success(list);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestGAUGUAKaLogList(APPDELEGATE.udid) parameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:pageNo],@"pageNo", nil]];
}



@end
