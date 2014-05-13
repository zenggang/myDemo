//
//  TouziType.h
//  FlatUILearning
//
//  Created by gang zeng on 14-5-12.
//  Copyright (c) 2014年 gang zeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouziType : NSObject
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int awardTimes;

+(AFHTTPRequestOperation *) buyTouziWithData:(NSString *) data OnSuccess:(void (^)(id))success failure:(void (^)(id))failure;
@end
