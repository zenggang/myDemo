//
//  Users.m
//  FlatUILearning
//
//  Created by gang zeng on 13-7-1.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import "Users.h"
#import "UserGold.h"

@implementation Users

- (id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self) {
        return nil;
    }
    if (![attributes isKindOfClass:[NSDictionary class]]) return self;
    
    _udid=[attributes objectForKey:@"udid"];
    _postDate=[attributes objectForKey:@"postDate"];
    _state =[[attributes objectForKey:@"state"] intValue];
    _qq =[attributes objectForKey:@"qq"];
    
    if ([attributes objectForKey:@"userExchangeNumber"]) {
        _userExchangeNumber = [[UserExchangeNumber alloc] initWithAttributes:[attributes objectForKey:@"userExchangeNumber"]];
    }
    
    if ([attributes objectForKey:@"userGoldList"]) {
        NSArray *goldList = [attributes objectForKey:@"userGoldList"];
        //log4Debug(goldList);
        _userGoldList =[NSMutableArray arrayWithCapacity:goldList.count];
        for (NSDictionary *obj in goldList) {
            UserGold *userGold = [[UserGold alloc ] initWithAttributes:obj];
            [_userGoldList addObject:userGold];
        }
    }
    _awardQqCount = [[attributes objectForKey:@"awardQqCount"] intValue];
    return self;
}

+(AFHTTPRequestOperation *) checkUserInfoOnSuccess:(void (^)(id))success firstTime:(void (^)(id))firstTime failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id JSON){
        if ([[JSON objectForKey:@"success"] intValue]==1) {
            if (firstTime) 
                firstTime(JSON);
        }else{
            Users *user = [[Users alloc] initWithAttributes:JSON];
            success(user);
        }
    }failure:^(id error){
        failure(error);
    }withPath:GOLDRequestCheckUser(APPDELEGATE.udid,APPDELEGATE.deviceToken) parameters:nil];
}

+(AFHTTPRequestOperation *) createUserOnSuccess:(void (^)(id))success failure:(void (^)(id))failure
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id JSON){
        Users *user = [[Users alloc] initWithAttributes:JSON];
        success(user);
    }failure:^(id error){
        failure(error);
    }withPath:GOLDRequestCreateUser(APPDELEGATE.udid) parameters:nil];
}

+(AFHTTPRequestOperation *) changeUserExchangeNuberInfo:(void (^)(id))success failure:(void (^)(id))failure
{
    UserExchangeNumber *exNO =APPDELEGATE.loginUser.userExchangeNumber;
    return [ApiRequestCenter sendPostRequestOnSuccess:^(id JSON){
        success(JSON);
    }failure:^(id error){
        failure(error);
    }withPath:GOLDRequestChangeExchangeNumberInfo(APPDELEGATE.udid) parameters:[NSMutableDictionary dictionaryWithObjectsAndKeys:(exNO.qq ? exNO.qq:@""),@"qq",(exNO.zhifubao ? exNO.zhifubao:@""),@"zhifubao",(exNO.cellphone ? exNO.cellphone :@""),@"cellphone", nil]];
}

+(AFHTTPRequestOperation *) bindingUserQQ:(void (^)(id))success failure:(void (^)(id))failure withQQ:(NSString *) qq
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id JSON){
        success(JSON);
    }failure:^(id error){
        failure(error);
    }withPath:GOLDRequestBindingQQ(APPDELEGATE.udid,qq) parameters:nil];
}

+(AFHTTPRequestOperation *) QqAward:(void (^)(id))success failure:(void (^)(id))failure withQQ:(NSString *) qq
{
    return [ApiRequestCenter sendGetRequestOnSuccess:^(id JSON){
        success(JSON);
    }failure:^(id error){
        failure(error);
    }withPath:GOLDRequestQqAward(APPDELEGATE.udid,qq) parameters:nil];
}

@end
