//
//  Users.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-1.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiRequestCenter.h"
#import "UserExchangeNumber.h"
@interface Users : NSObject
@property (nonatomic,strong) NSString *udid;
@property (nonatomic,strong) NSString *postDate;
@property (nonatomic,assign) int state;
@property (nonatomic,strong) NSString *qq;
@property (nonatomic,strong) UserExchangeNumber *userExchangeNumber;
@property (nonatomic,strong) NSMutableArray *userGoldList;
@property (nonatomic,assign) int awardQqCount;

- (id)initWithAttributes:(NSDictionary *)attributes;
+(AFHTTPRequestOperation *) checkUserInfoOnSuccess:(void (^)(id))success firstTime:(void (^)(id))firstTime failure:(void (^)(id))failure;
+(AFHTTPRequestOperation *) createUserOnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
+(AFHTTPRequestOperation *) changeUserExchangeNuberInfo:(void (^)(id))success failure:(void (^)(id))failure;
+(AFHTTPRequestOperation *) bindingUserQQ:(void (^)(id))success failure:(void (^)(id))failure withQQ:(NSString *) qq;
+(AFHTTPRequestOperation *) QqAward:(void (^)(id))success failure:(void (^)(id))failure withQQ:(NSString *) qq;
@end
