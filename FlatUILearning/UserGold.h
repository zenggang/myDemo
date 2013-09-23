//
//  UserGold.h
//  FlatUILearning
//
//  Created by gang zeng on 13-7-2.
//  Copyright (c) 2013年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserGold : NSObject

@property (nonatomic,strong) NSString *udid;
@property (nonatomic,assign) int pid;
@property (nonatomic,assign) int goldAmount;

- (id)initWithAttributes:(NSDictionary *)attributes;

+(AFHTTPRequestOperation *) addGoldOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withGoldData:(NSString *) data withSecret:(NSString *) secretKey;

+(AFHTTPRequestOperation *) deductingGoldOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withGoldData:(NSString *) data;

+(AFHTTPRequestOperation *) synchroGoldOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withGoldData:(NSString *) data;
+(AFHTTPRequestOperation *) getUserGifGodOnSuccess:(void (^)(id))success failure:(void (^)(id))failure ;
+(AFHTTPRequestOperation *) ExcgangeGoldOnSuccess:(void (^)(id))success failure:(void (^)(id))failure withreciveNumber:(NSString *) reciveNo withData:(NSString *) data withTypeId:(int)typeId withSecret:(NSString *) secretKey;
+(AFHTTPRequestOperation *) getWeixinAwardWithType:(NSString *) type OnSuccess:(void (^)(id))success failure:(void (^)(id))failure ;
@end
