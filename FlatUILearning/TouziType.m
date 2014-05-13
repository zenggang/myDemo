//
//  TouziType.m
//  FlatUILearning
//
//  Created by gang zeng on 14-5-12.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import "TouziType.h"

@implementation TouziType

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _awardTimes=[[attributes objectForKey:@"awardTimes"] integerValue];
    _number=[[attributes objectForKey:@"number"] integerValue];
    
    return self;
}

+(AFHTTPRequestOperation *) buyTouziWithData:(NSString *) data OnSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendPostRequestOnSuccess:^(id json) {
        
        if (success) {
            success(json);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestBuyDazuanpan(APPDELEGATE.udid) parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:data,@"data", nil]];
}

@end
