//
//  LaohuJiType.h
//  FlatUILearning
//
//  Created by gang zeng on 14-2-1.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaohuJiType : NSObject
@property (nonatomic, assign) int lid;
@property (nonatomic, assign) int awardTimes;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) int count;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *type;

+(AFHTTPRequestOperation *) getLahujiListOnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
+(AFHTTPRequestOperation *) buyLaoHujiWithData:(NSString *) data OnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
@end
