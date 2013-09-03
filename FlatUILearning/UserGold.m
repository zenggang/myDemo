//
//  UserGold.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-2.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "UserGold.h"


@implementation UserGold

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    if (![attributes isKindOfClass:[NSDictionary class]]) return self;
    
    _udid=[attributes objectForKey:@"udid"];
    _pid=[[attributes objectForKey:@"pid"] intValue];
    _goldAmount =[[attributes objectForKey:@"goldAmount"] intValue];

    return self;
}


+(AFHTTPRequestOperation *) ExcgangeGoldOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withreciveNumber:(NSString *) reciveNo withData:(NSString *) data withTypeId:(int)typeId withSecret:(NSString *) secretKey {
    NSMutableDictionary *param =[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:typeId],@"typeId",reciveNo,@"receiveNumber",data,@"data",secretKey,@"secretKey", nil];
    return [ApiRequestCenter sendPostRequestOnSuccess:^(id json) {
        if (success) {
            success(json);
        } 
    } failure:^(id error) {
        if (failure) {
            [AppUtilities handleErrorMessage:error];
            failure(error);
        }
    } withPath:GOLDRequestExchangeGold(APPDELEGATE.udid) parameters:param];
}

+(AFHTTPRequestOperation *) addGoldOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withGoldData:(NSString *) data withSecret:(NSString *) secretKey{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(id error) {
        if (failure) {
            [AppUtilities handleErrorMessage:error];
            failure(error);
        }
    } withPath:GOLDRequestAddGold(APPDELEGATE.udid, data,secretKey) parameters:nil];
}
+(AFHTTPRequestOperation *) deductingGoldOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withGoldData:(NSString *) data {
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(id error) {
        if (failure) {
            [AppUtilities handleErrorMessage:error];
            failure(error);
        }
    } withPath:GOLDRequestDeductingGoldGold(APPDELEGATE.udid, data) parameters:nil];
}


+(AFHTTPRequestOperation *) synchroGoldOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withGoldData:(NSString *) data{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        if (success) {
            success(json);
        }
    } failure:^(id error) { 
        if (failure) {
            [AppUtilities handleErrorMessage:error];
            failure(error);
        }
    } withPath:GOLDRequestSynchroGold(APPDELEGATE.udid,data) parameters:nil];
}
+(AFHTTPRequestOperation *) getUserGifGodOnSuccess:(void (^)(id))success failure:(void (^)(id))failure {
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        if (success) {
            UserGold *gold =[[UserGold alloc] initWithAttributes:json];
            success(gold);
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDRequestGifGold(APPDELEGATE.udid) parameters:nil];
}

+(AFHTTPRequestOperation *) getWeixinAwardOnSuccess:(void (^)(id))success failure:(void (^)(id))failure {
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id json) {
        if (success) { 
            success(json); 
        }
    } failure:^(id error) {
        if (failure) {
            failure(error);
        }
    } withPath:GOLDWEINXINGShareAwardGold(APPDELEGATE.udid) parameters:nil];
}
@end
