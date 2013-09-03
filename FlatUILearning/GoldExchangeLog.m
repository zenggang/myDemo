//
//  GoldExchangeLog.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-4.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "GoldExchangeLog.h"

@implementation GoldExchangeLog


- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    if (![attributes isKindOfClass:[NSDictionary class]]) return self;
    
    _udid=[attributes objectForKey:@"udid"];
    _eid=[[attributes objectForKey:@"eid"] intValue];
    _postDate=[attributes objectForKey:@"postDate"];
    _receiveNumber=[attributes objectForKey:@"receiveNumber"];
    _exchangeDate=[attributes objectForKey:@"exchangeDate"];
    _typeContent=[attributes objectForKey:@"typeContent"];
    _typeId=[[attributes objectForKey:@"typeId"] intValue];
    _state=[[attributes objectForKey:@"state"] intValue];
    _goldAmount =[[attributes objectForKey:@"goldAmount"] intValue];
    return self;
}

+(AFHTTPRequestOperation *) getUserExchangeLogOnSuccess:(void (^)(id))success failure:(void (^)(id))failure pageNo:(int) pageNo{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        
        if (success) {
            NSMutableArray *mutableArray=[NSMutableArray arrayWithCapacity:[json count]];
            for (NSDictionary *attribute in json) {
                GoldExchangeLog *goldExLog=[[GoldExchangeLog alloc] initWithAttributes:attribute];
                [mutableArray addObject:goldExLog];
            }
            success(mutableArray);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestUserExchangeLog(APPDELEGATE.udid,pageNo) parameters:nil];
}

@end
