//
//  LaohuJiType.m
//  FlatUILearning
//
//  Created by gang zeng on 14-2-1.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import "LaohuJiType.h"

@implementation LaohuJiType

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _lid=[[attributes objectForKey:@"lid"] integerValue];
    _awardTimes=[[attributes objectForKey:@"awardTimes"] integerValue];
    _state=[[attributes objectForKey:@"state"] integerValue];
    _count=[[attributes objectForKey:@"count"] integerValue];
    
    _name=[attributes objectForKey:@"name"];
    _type=[attributes objectForKey:@"type"];
    return self;
}


+(AFHTTPRequestOperation *) getLahujiListOnSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        
        NSMutableArray *list =[NSMutableArray arrayWithCapacity:[json count]];
        if (success) {
            for (NSDictionary *temp in json) {
                LaohuJiType *laohuji =[[LaohuJiType alloc] initWithAttributes:temp];
                [list addObject:laohuji];
            }
            success(list);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestLaoHuJiList parameters:nil];
}

+(AFHTTPRequestOperation *) buyLaoHujiWithData:(NSString *) data OnSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendPostRequestOnSuccess:^(id json) {
        
        if (success) {
            success(json);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestBuyLaoHuJi(APPDELEGATE.udid) parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:data,@"data", nil]];
}
@end
