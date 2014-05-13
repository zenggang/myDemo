//
//  Dazuanpan.h
//  FlatUILearning
//
//  Created by gang zeng on 14-5-7.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dazuanpan : NSObject
@property (nonatomic, assign) int typeId;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int awardTimes;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) int rate;


+(AFHTTPRequestOperation *) getDazuanpanListOnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
+(AFHTTPRequestOperation *) buyDazuanpanWithData:(NSString *) data OnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
@end
