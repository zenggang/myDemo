//
//  Dazuanpan.m
//  FlatUILearning
//
//  Created by gang zeng on 14-5-7.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import "Dazuanpan.h"

@implementation Dazuanpan
- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _typeId=[[attributes objectForKey:@"typeId"] integerValue];
    _awardTimes=[[attributes objectForKey:@"awardTimes"] integerValue];
    _state=[[attributes objectForKey:@"state"] integerValue];
    _number=[[attributes objectForKey:@"number"] integerValue];
    _rate=[[attributes objectForKey:@"rate"] integerValue];
    
    return self;
}


+(AFHTTPRequestOperation *) getDazuanpanListOnSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        
        NSMutableArray *list =[NSMutableArray arrayWithCapacity:[json count]];
        if (success) {
            for (NSDictionary *temp in json) {
                Dazuanpan *dazuanpan =[[Dazuanpan alloc] initWithAttributes:temp];
                [list addObject:dazuanpan];
            }
            success(list);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestDazuanpanList parameters:nil];
}


+(AFHTTPRequestOperation *) buyDazuanpanWithData:(NSString *) data OnSuccess:(void (^)(id))success failure:(void (^)(id))failure
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
